Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B0E3220B8C
	for <lists+io-uring@lfdr.de>; Wed, 15 Jul 2020 13:12:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729563AbgGOLMY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Jul 2020 07:12:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728265AbgGOLMW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Jul 2020 07:12:22 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83688C08C5DD
        for <io-uring@vger.kernel.org>; Wed, 15 Jul 2020 04:12:22 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id f12so1727559eja.9
        for <io-uring@vger.kernel.org>; Wed, 15 Jul 2020 04:12:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=GNZTlebsq0eWIwEljX2xeBdZEHRs2k6AtH87hm9Zwgg=;
        b=JZLRSBhWm0oHxV3fok6cxthIXvhjAenz53D8fezRJjLbsEGzev4V175VrT5tTOPQ0L
         XAnaq/Ov0CMEsnpV/F+V8rK7u1bIHghoUkChEQwbMY9tpBz4kn9ZGAYdf+rjrsnXqUDy
         +MzGC5vqoZD/qK6UbJ4A75mLpvNLy6Zar3ArQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=GNZTlebsq0eWIwEljX2xeBdZEHRs2k6AtH87hm9Zwgg=;
        b=YyLdX6N3+Pm5z7SFWmolsDXn0TMclR2vrk2iDl2Vv0xP25g4QDtEP8vZLIk8iw0nnb
         CvuN/7KrHvUu9LndHTc5QXYU1ZWUqoR7XDTylmha+bc+8DGbUGAMsURXUDFoHKI7nPpJ
         /Pqh+hTgMS4rO8vQlkaPqst/jxJIffs8MVwxCnrhGQ6IOYGZwqKBhp2AoiqKJj3keAsW
         1rKDSiTlv6oQOQe7o1YyEE44VQJ8rP57jrlsR4PSHTcKHE98fAk8HzF7/87b4uPnd1Uk
         JepLIm+h/A2emCocyXHZ7mvS9/7MAeG1R0xJP2V62i/nirmN8nJcIt0X0YyHPeCstii1
         J1Xg==
X-Gm-Message-State: AOAM531y9fySpA8byIWxY82jJcIID9xCB54+IYKj+lMckSFeFwEC5+4i
        lFD5AUREMt3IbWvMj5ZPMP7+uhUa0qM2mHS/QWbmJw==
X-Google-Smtp-Source: ABdhPJw0oIZdNNSQSx2dAWVRtVjY5tScV5cqBbhIhCHnr1dD6YokQZCqwZVPmd0NLTWPqfK15c8L+dhgVb8e5/u5u6o=
X-Received: by 2002:a17:906:b74e:: with SMTP id fx14mr8403146ejb.202.1594811541019;
 Wed, 15 Jul 2020 04:12:21 -0700 (PDT)
MIME-Version: 1.0
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Wed, 15 Jul 2020 13:12:09 +0200
Message-ID: <CAJfpegu3EwbBFTSJiPhm7eMyTK2MzijLUp1gcboOo3meMF_+Qg@mail.gmail.com>
Subject: strace of io_uring events?
To:     strace-devel@lists.strace.io, io-uring@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Linux API <linux-api@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

This thread is to discuss the possibility of stracing requests
submitted through io_uring.   I'm not directly involved in io_uring
development, so I'm posting this out of  interest in using strace on
processes utilizing io_uring.

io_uring gives the developer a way to bypass the syscall interface,
which results in loss of information when tracing.  This is a strace
fragment on  "io_uring-cp" from liburing:

io_uring_enter(5, 40, 0, 0, NULL, 8)    = 40
io_uring_enter(5, 1, 0, 0, NULL, 8)     = 1
io_uring_enter(5, 1, 0, 0, NULL, 8)     = 1
...

What really happens are read + write requests.  Without that
information the strace output is mostly useless.

This loss of information is not new, e.g. calls through the vdso or
futext fast paths are also invisible to strace.  But losing filesystem
I/O calls are a major blow, imo.

What do people think?

From what I can tell, listing the submitted requests on
io_uring_enter() would not be hard.  Request completion is
asynchronous, however, and may not require  io_uring_enter() syscall.
Am I correct?

Is there some existing tracing infrastructure that strace could use to
get async completion events?  Should we be introducing one?

Thanks,
Miklos
