Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8B1F2506DE
	for <lists+io-uring@lfdr.de>; Mon, 24 Aug 2020 19:48:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726870AbgHXRsu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Aug 2020 13:48:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726661AbgHXRsu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Aug 2020 13:48:50 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04A51C061573
        for <io-uring@vger.kernel.org>; Mon, 24 Aug 2020 10:48:50 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id d18so266574iop.13
        for <io-uring@vger.kernel.org>; Mon, 24 Aug 2020 10:48:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=sdeSqMirw+foGwElawVONvtaro86x3slIaIXpjcD7Gc=;
        b=qrW+XdaMgHRWljhLNQB4ttQVigJhS4KeHpzD6tgKKEciOUnOefpcUzM0RdmcgDZjOP
         a8nvEXtxx6bzIS3kagYHoGRoSLcLZmDu7GBzkbwfcRUJRoXavdHx4EnpvbC1T8lXUopw
         SBbwLdlJwVmrxLHkgxg7YpejUoa9Uuvy1hlE3FIRctBJHQKPRweYpyKUPdm8ykQy/Sg7
         EDuTK6PygKXMxP1jWfC9XbMuIVieBMMn0+PbYU4ljmt8IguaZvS45nGZRA1uQ+8jDGCu
         xyKk9Yu2H2JIYNaE8LT6M8raPVNSxvpQWbeesptdY/omPhrPCrjbHIZYq8Uh0OUsop8L
         ODiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=sdeSqMirw+foGwElawVONvtaro86x3slIaIXpjcD7Gc=;
        b=Cu2B/IhRTEaPOvbXc2HxKgGG/H5ftgZ4+sZTd2PPJYL1GfCM36c+WZlH5auJ06wKl4
         JV2uX/qjteDtH27xfJQhfQCVC0E9J03lA9nDpezTxDxVKOrhMLf5EauFujBEyI1HR7zO
         eLJTC/NJUTYDD5/0yKjyrUw6nK0Pt1ly8nwNJUyZYpfanrE6ZCICvg2fh84ZtgDBuQSz
         qmfyvnYoIDdL/OG/I20AkuIvSjoUXhTmQYXBcdnDdsE+1peSSOrZEem8sHpLVx2DP5WJ
         PNANKVFkGG5ZofaQvDehdMJxyZv6VXLN/S8B/CGEaTlbvYEc2fg8P+y249VLV6csjPKS
         dHaA==
X-Gm-Message-State: AOAM531D07l3LXhfYX0PNP32ibRf+yUaLxJ456aEki4RhSnsxeXT5LW1
        3uu5+8SUcPt/JIq5K4AAYPppeC4VKXfVdokr
X-Google-Smtp-Source: ABdhPJylkQ9XwX+/n3MnlWbMp+jW/nftHADAvOjOJVgQkQ65NteQOYORFa5w2QL0XETbGhh1rAFvPw==
X-Received: by 2002:a6b:e216:: with SMTP id z22mr5493767ioc.97.1598291325150;
        Mon, 24 Aug 2020 10:48:45 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id l5sm7490506ios.3.2020.08.24.10.48.44
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Aug 2020 10:48:44 -0700 (PDT)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: revert consumed iov_iter bytes on error
Message-ID: <a2e5bc52-d31a-3447-c4be-46d6bb1fd4b8@kernel.dk>
Date:   Mon, 24 Aug 2020 11:48:44 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Some consumers of the iov_iter will return an error, but still have
bytes consumed in the iterator. This is an issue for -EAGAIN, since we
rely on a sane iov_iter state across retries.

Fix this by ensuring that we revert consumed bytes, if any, if the file
operations have consumed any bytes from iterator. This is similar to what
generic_file_read_iter() does, and is always safe as we have the previous
bytes count handy already.

Fixes: ff6165b2d7f6 ("io_uring: retain iov_iter state over io_read/io_write calls")
Reported-by: Dmitry Shulyak <yashulyak@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c9d526ff55e0..e030b33fa53e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3153,6 +3153,8 @@ static int io_read(struct io_kiocb *req, bool force_nonblock,
 	} else if (ret == -EAGAIN) {
 		if (!force_nonblock)
 			goto done;
+		/* some cases will consume bytes even on error returns */
+		iov_iter_revert(iter, iov_count - iov_iter_count(iter));
 		ret = io_setup_async_rw(req, iovec, inline_vecs, iter, false);
 		if (ret)
 			goto out_free;
@@ -3294,6 +3296,8 @@ static int io_write(struct io_kiocb *req, bool force_nonblock,
 	if (!force_nonblock || ret2 != -EAGAIN) {
 		kiocb_done(kiocb, ret2, cs);
 	} else {
+		/* some cases will consume bytes even on error returns */
+		iov_iter_revert(iter, iov_count - iov_iter_count(iter));
 copy_iov:
 		ret = io_setup_async_rw(req, iovec, inline_vecs, iter, false);
 		if (!ret)

-- 
Jens Axboe

