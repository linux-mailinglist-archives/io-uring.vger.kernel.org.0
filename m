Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F407C242C48
	for <lists+io-uring@lfdr.de>; Wed, 12 Aug 2020 17:45:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726568AbgHLPpT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 12 Aug 2020 11:45:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726226AbgHLPpS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 12 Aug 2020 11:45:18 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D32FC061383
        for <io-uring@vger.kernel.org>; Wed, 12 Aug 2020 08:45:18 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id p24so2740142ejf.13
        for <io-uring@vger.kernel.org>; Wed, 12 Aug 2020 08:45:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=tx2Ld3D1QN788afouwVEAIEIPUtwEnjpJmPmwDKplZk=;
        b=lyfUziip7Y11+v8BzY0ytFpZffs8OGhaQ5JwudesFEKwFwSXvnJSs2IEN7vUfXolTx
         W8clDUw9ifKulXeWu572wYoJLO3p64qCoSqCZwG22+Vc1/w377dVYXsX5Y0jCX7SYqAY
         5t20EMVGmX3yBWRIsBj+64YUlfGtRx+Fp+EE38a8Ceq3rudn+WekqMxaEt1Fspye79HV
         8k+TvtHldW81+WeVZR+KMrYD5zSjMkVnzFvT1SB6MZacd1jVQk694kFTmjazzmwqCio0
         4ZZVb23nx+yngphe8E6MkpCydXppW2jiXdJ8bdgKBNRT80YBU8JyxA6dPW0VlNBHCYLE
         /kcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=tx2Ld3D1QN788afouwVEAIEIPUtwEnjpJmPmwDKplZk=;
        b=aS+3bKkmDSzi+gfiUKH3eRRhaj09DXBHFBj+ymLrILjGlXOCt01wazCV8LSMyWBJGn
         g/XSxxZFNPTwjO4zvTydlS01/F1j1+omqUebnbQIb92169qFO71dgK7n/yob05ZhBjjt
         Qthw7kKEa8G/SOg1VGnKOo+Kf3KEeDefUVbyziq+xNK26XWniO1z9VHJ3g8t+FgTn+JD
         jXmUnz6g+Oh5Yzh57+ZgsqeCMzmuL26Uaz2l+xs9Zy0YWQEsp26advfE7ZEZbBaLFbk6
         auXDpW8G92aSCRuQ66uvtU3n/1W3w+y1is2l+bxCyJZ4tZcDUTHFFyyrAZ5UnlypsV2A
         spRw==
X-Gm-Message-State: AOAM533+wqan5itpQDcZvFHmJFSCB80PLfsbvyzq9tebVkJHoLecfyOp
        EKKAmE6ILhsgs2tTivfLWnZqKM8GY5pa4oc2IeKmIg3fKK06+g==
X-Google-Smtp-Source: ABdhPJzSGgvQKSnlxrKA3TUupjmP00TMST1K+xDMstbJ9d0YYxFrR9lgRm51mYb8BrZpt9DP3+4lDr18BZUVgDB+nl0=
X-Received: by 2002:a17:906:819:: with SMTP id e25mr401097ejd.95.1597247113709;
 Wed, 12 Aug 2020 08:45:13 -0700 (PDT)
MIME-Version: 1.0
From:   Shuveb Hussain <shuveb@gmail.com>
Date:   Wed, 12 Aug 2020 21:15:02 +0530
Message-ID: <CAF=AFaKBvUNjWx0-N9bR3z14dPBUzkcCR-4S5de-_=ovda7Fjw@mail.gmail.com>
Subject: Question regarding process context
To:     io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

I added a new operation for signalfd() and got it working. However,
the kernel's signalfd implementation uses "current" to get process
context details and adds the current process to a wait queue. When
trying to wake up, however, it gets called from the io_wqe_worker
context and the wake up would not normally happen since current now
resolves to io_wqe_worker. I've taken care of this by saving "current"
in the struct file's private_data when submitting and using that
instead during completion from the signalfd code. It works.
Essentially, current resolves to different tasks in the submission and
completion paths and this had to be taken care of for signalfd.

However, under io_uring, there are many cases where current will not
resolve to the user space process. For example, when being called from
io_sq_thread.

Since io_uring deals with calling code that originally implements
paths that are called from various system calls, they might internally
use current. What is the general strategy to handle the fact that
current can point to different tasks when submitting and completing?

Thanks!
-- 
Shuveb Hussain
