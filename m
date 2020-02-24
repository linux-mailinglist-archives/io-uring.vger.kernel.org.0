Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 001B4169C71
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2020 03:56:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727170AbgBXC4N (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 23 Feb 2020 21:56:13 -0500
Received: from mail-pj1-f43.google.com ([209.85.216.43]:52308 "EHLO
        mail-pj1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727158AbgBXC4N (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 23 Feb 2020 21:56:13 -0500
Received: by mail-pj1-f43.google.com with SMTP id ep11so3516223pjb.2
        for <io-uring@vger.kernel.org>; Sun, 23 Feb 2020 18:56:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2k4oEFJqOc6P4v9XEPQ/6R16qypCMvjSENnhP9CZNO8=;
        b=jNPhpPFvM0euSw3l/XDI3EB2NyOAKOPskEZ718UpQLr59umYPKcy1u7O8aR6IBz5kw
         GkqqPy0gnCz86JQuOrdlLm5t30Q7tiZL1GFHjsscBnD2JlJdb3EGFhHL8wTZZFNM4v6M
         Gu2N1UjbWagvJqS08+LrjWXb6ZE/LUgI62rpU1oLH53+hmxD98F3JMi8+dfsjgi5nHR2
         Scp8yeQ3wvkuaeaWFu6ZDKpaafTMcozEkF3d7iGLiOv0JT+0F/wQ24UDEV+q8xQLtIk4
         k83QMgxvWr4FP4np2cnUPs1A/0qwzJxYi9VdMeXOl42r0X7mQVRF3D2KX7SuCDW0sgIK
         eo+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2k4oEFJqOc6P4v9XEPQ/6R16qypCMvjSENnhP9CZNO8=;
        b=m2rlnCXZhmewT1cFv1kjg6kDF3sHxEDB2Nu7d1OHmE9Jw4uPJ72OYbHwaF7cCqSjnZ
         zx/eLXFnCF5m0GhXi+vYC4718VgUa/RJtzC4WXvEXlmZB15sg//E/+UhZAml45IgLXbt
         pM41NIG27pE4GCDIe7s1NKFfX8AyekqJfmMyIB0L0t31a4sLCSYxzFANWSLuPdMxXJIF
         0IqdFode4U3UJ4yKWaxvkloc/Jv1ViFlVefAAzNRIyIK/Bp2VaybiDr4p3n9Am8QlgTC
         WwhcSrpUo+7WuvouBEcjJq1+DKpwMsSwNOqGxD4aQUzmGUa8dwq7GpDcATkNZhhJ3pfi
         VYkg==
X-Gm-Message-State: APjAAAXNr7CMSnHDE9Q8+X7RizCRHfY55zogak7N3GPS/wH5TGm0Tsr8
        PKE9eMON44LZILHEHzMTkYujKV5xqz0=
X-Google-Smtp-Source: APXvYqwgOctS9VakukGp/hrAxReFGs6eRQfyBhtSf7F6m+Ugo6JMZJMSVyTCglLlull8wnvtvpZwpA==
X-Received: by 2002:a17:902:41:: with SMTP id 59mr49769175pla.39.1582512971996;
        Sun, 23 Feb 2020 18:56:11 -0800 (PST)
Received: from x1.localdomain ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id z5sm10859169pfq.3.2020.02.23.18.56.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Feb 2020 18:56:11 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     andres@anarazel.de
Subject: [PATCHSET 0/3] io_uring support for automatic buffers
Date:   Sun, 23 Feb 2020 19:56:04 -0700
Message-Id: <20200224025607.22244-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

With the poll retry based async IO patchset I posted last week, the one
big missing thing for me was the ability to have automatic buffer
selection. Generally applications that handle tons of sockets like to
poll for activity on them, then issue IO when they become ready. This is
of course at least two system calls, but it also means that it provides
an application a chance to manage how many IO buffers it needs. With the
io_uring based polled IO, the application need only issue an
IORING_OP_RECV (for example, to receive socket data), it doesn't need to
poll at all. However, this means that the application no longer has an
opportune moment to select how many IO buffers to keep in flight, it has
to be equal to what it currently has pending.

I had originally intended to use BPF to provide some means of buffer
selection, but I had a hard time imagining how life times of the buffer
could be managed through that. I had a false start today, but Andres
suggested a nifty approach that also solves the life time issue.

Basically the application registers buffers with the kernel. Each buffer
is registered with a given group ID, and buffer ID. The buffers are
organized by group ID, and the application selects a buffer pool based
on this group ID. One use case might be to group by size. There's an
opcode for this, IORING_OP_PROVIDE_BUFFER.

With that, when doing the same IORING_OP_RECV, no buffer is passed in
with the request. Instead, it's flagged with IOSQE_BUFFER_SELECT, and
sqe->buf_group is filled in with a valid group ID. When the kernel can
satisfy the receive, a buffer is selected from the specified group ID
pool. If none are available, the IO is terminated with -ENOBUFS. On
success, the buffer ID is passed back through the (CQE) completion
event. This tells the application what specific buffer was used.

A buffer can be used only once. On completion, the application may
choose to free it, or register it again with IORING_OP_PROVIDE_BUFFER.

Patches can also be found in the below repo:

https://git.kernel.dk/cgit/linux-block/log/?h=io_uring-buf-select

and they are obviously layered on top of the poll retry rework.

-- 
Jens Axboe



