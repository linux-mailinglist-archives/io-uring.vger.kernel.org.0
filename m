Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4F2224C958
	for <lists+io-uring@lfdr.de>; Fri, 21 Aug 2020 02:46:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726347AbgHUAqf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Aug 2020 20:46:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725859AbgHUAqe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Aug 2020 20:46:34 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF31DC061385
        for <io-uring@vger.kernel.org>; Thu, 20 Aug 2020 17:46:32 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id q16so152974ybk.6
        for <io-uring@vger.kernel.org>; Thu, 20 Aug 2020 17:46:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=datadoghq.com; s=google;
        h=mime-version:from:date:message-id:subject:to;
        bh=YpwVRjYKfQSKC+37NS+1EsbQDFqOk82fhgEI7gmadM0=;
        b=AQfdq51KTNUhV6pH8Kmo715x+zLvnEyP2b8AIy64dNGDgAl14RSmV53v8b/wB/J6SL
         QVS0de8//QAHRikDUHNyfmRH6JL15QB2S8jLSEAIAS4TeUyHwJIWCXjVwErtvMFb6gng
         LppvCyPq7oaJWwO4q8Pw6bMSTizpZmv/gyFOs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=YpwVRjYKfQSKC+37NS+1EsbQDFqOk82fhgEI7gmadM0=;
        b=Ri2+1YWho6FRC8nb7DbJi/+QUptcRH/0LAyyHZwGNsGXZT7cCtNOVN4gpbdPG33KOw
         lx2eRzyZrEO7jhp3euXrbKzX1kGLTbGqD1SZ8+UOV9qDTpxcmlBfW2eA6d0nw+9ra08U
         YzJdcQc1i7xvBn7YF6/yYkePSNTNHFnb2mDM+5UJvM7vp6CEZSVVULfQBRxtzf8MaeLr
         ak4n0ZxHbkeMAhx41wTt61tFF/yCGxgvIwZ0bRr3MH0XF24MUcXtSnfp4bGJBnJVicyj
         LMugIkzTj6F1n0jT3AWcoxEKzEkfJxE/KEB6WkZGMyizi4R7FSI7aJiWY/RZRSMw4sqn
         fqHw==
X-Gm-Message-State: AOAM532IfoQy4XvXtZC3pPCM4ZKXfisNkizIXdvhgoaRpwFOtzJtnx5U
        5Kk67RtfceQkK/7A1Kln9TEUrKWb4KHECqK4DjzSZXHMQzIc92k7
X-Google-Smtp-Source: ABdhPJwOwggducIhSqYj6HAwcBw8U4MOBSV/Tn9rl+sWAptIxjlyPEd1RikNUrFKU3evQR5yj1OK4viXcMzu3eqmAQ0=
X-Received: by 2002:a25:ce07:: with SMTP id x7mr607030ybe.18.1597970789097;
 Thu, 20 Aug 2020 17:46:29 -0700 (PDT)
MIME-Version: 1.0
From:   Glauber Costa <glauber.costa@datadoghq.com>
Date:   Thu, 20 Aug 2020 20:46:18 -0400
Message-ID: <CAMdqtNXQbQazseOuyNC_p53QjstsVqUz_6BU2MkAWMMrxEuJ=A@mail.gmail.com>
Subject: Poll ring behavior broken by f0c5c54945ae92a00cdbb43bdf3abaeab6bd3a23
To:     io-uring@vger.kernel.org, axboe@kernel.dk,
        xiaoguang.wang@linux.alibaba.com
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

I have just noticed that the commit in $subject broke the behavior I
introduced in
bf3aeb3dbbd7f41369ebcceb887cc081ffff7b75

In this commit, I have explained why and when it does make sense to
enter the ring if there are no sqes to submit.

I guess one could argue that in that case one could call the system
call directly, but it is nice that the application didn't have to
worry about that, had to take no conditionals, and could just rely on
io_uring_submit as an entry point.

Since the author is the first to say in the patch that the patch may
not be needed, my opinion is that not only it is not needed but in
fact broke applications that relied on previous behavior on the poll
ring.

Can we please revert?
