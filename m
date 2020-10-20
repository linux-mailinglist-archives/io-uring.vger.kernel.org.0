Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9C01293E5A
	for <lists+io-uring@lfdr.de>; Tue, 20 Oct 2020 16:12:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407886AbgJTOMK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 20 Oct 2020 10:12:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407848AbgJTOMJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 20 Oct 2020 10:12:09 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1E32C061755
        for <io-uring@vger.kernel.org>; Tue, 20 Oct 2020 07:12:09 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id n6so3462843ioc.12
        for <io-uring@vger.kernel.org>; Tue, 20 Oct 2020 07:12:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=oTfciUemt3gEsGh5HmdSKqqiK9r4DjVHfMExAjvs6Ms=;
        b=T7OHUviwbDC1PpURTTf5dMwnvt4ulSb5aLnooGETLc4v32iAfpmwDq6XfDsB3eQcJu
         dt5ura0eajFSx0Az80XX99hJ7ggJGhigohsMzZKfmkUKYRg2Kz9GMa+ssh8jiXI0RQcp
         0lv1sqFV5e5x55gycpEiutzUaYq+hiedlBqkN9uVeiiiSqtP2k74+JlEuWG5oCZF1JBl
         jFuR49cLAO/foK9DASlkk3K3C6c5lnvLrEA76OLeYQcwh7jVMsyDsW7q2RYJW6ak78wz
         uvfdIaHwqVlLa6z8oGlcZJ9i84DagGr5NaSCzLbog7ehIw3TqdenECHGxpZKXQBK+3ZK
         iUBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oTfciUemt3gEsGh5HmdSKqqiK9r4DjVHfMExAjvs6Ms=;
        b=qz7WHRhVvpEgL/9zY/PczIiidKz7F8KVpR+GTebKyjKVXC5/15tb5vXELONJZCmLVV
         Upvt+xTxyWEA6IiFXR5BsHJK0cQdYeSHGbALpIny58zXhSg+4YpT0i/HZJG6vlA6cpLm
         iXqf7M/U8kW7gwkOGJWFlsXfSA6A8MFCXS0E6MhUztXyiIS9sZheLeumSzOlf38lJofd
         7WjiWINAO9VRm67gRLQbnA0TBo+s7G8NRDQTCMnXmcyhAs1EqJrmMhHvn8mqEUJBF3sP
         OUcN0mLUxLIyggb6Epas4kvzbfyR0QuLMw9bkPtTcmtqyXWwrjGx+pRVaoZzTkmh9BAF
         ubLA==
X-Gm-Message-State: AOAM532UK9nk/XNJsUITeiOm+bZlqnTAQ30M2Ejxx0UakwSQOOyHnyea
        UFF8hb9kPcUSbtnTUQOZCRTDm8bEpn/CjQ==
X-Google-Smtp-Source: ABdhPJylGQDwecBIfJyyRXHMjgSl0MzVLw97Ij3YBUKJo5I+sPq8QFZ+F/9EdvesgUpBznn6mqI9VQ==
X-Received: by 2002:a5d:9e0c:: with SMTP id h12mr2236849ioh.163.1603203128850;
        Tue, 20 Oct 2020 07:12:08 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id d26sm2122534ill.83.2020.10.20.07.12.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Oct 2020 07:12:08 -0700 (PDT)
Subject: Re: [PATCH liburing] test/lfs-open: less limited test_drained_files
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <d6fd0e761f9daafcd4a8092117dfd751c94f2a06.1603122173.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <f7625f7f-86e5-fd4a-4f71-ae76110dfd68@kernel.dk>
Date:   Tue, 20 Oct 2020 08:12:08 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <d6fd0e761f9daafcd4a8092117dfd751c94f2a06.1603122173.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/19/20 9:46 AM, Pavel Begunkov wrote:
> close(dup(io_uring)) should not neccessary cancel all requests with
> files, because files are not yet going away. Test that it doesn't hang
> after close() and exits, that's enough.

Applied with the below incremental.


diff --git a/test/lfs-openat.c b/test/lfs-openat.c
index 3fa0b99db1b3..b14238a9a41d 100644
--- a/test/lfs-openat.c
+++ b/test/lfs-openat.c
@@ -133,10 +133,9 @@ static int test_drained_files(int dfd, const char *fn, bool linked, bool prepend
 {
 	struct io_uring ring;
 	struct io_uring_sqe *sqe;
-	struct io_uring_cqe *cqe;
 	char buffer[128];
 	struct iovec iov = {.iov_base = buffer, .iov_len = sizeof(buffer), };
-	int i, ret, fd, fds[2], to_cancel = 0;
+	int ret, fd, fds[2], to_cancel = 0;
 
 	ret = io_uring_queue_init(10, &ring, 0);
 	if (ret < 0)

-- 
Jens Axboe

