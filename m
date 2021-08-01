Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 683E93DC90F
	for <lists+io-uring@lfdr.de>; Sun,  1 Aug 2021 02:11:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbhHAALL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 31 Jul 2021 20:11:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229664AbhHAALL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 31 Jul 2021 20:11:11 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75572C06175F;
        Sat, 31 Jul 2021 17:11:04 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id h24-20020a1ccc180000b029022e0571d1a0so8780858wmb.5;
        Sat, 31 Jul 2021 17:11:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SEyoGWjUYXqXQWlOLgilVFtItLgtihW+VfcSKV/3elE=;
        b=mPkDD5HAtCOu3LFJFeCZDu1Nd03vsVHygs2Zkl05WmB/NdqaM4opFQjB+/mDco1eiq
         NxukjRZJP6lWX3eG/iW6mSnL+kJxL9Fo7Q794TJq098W4Jr3+0ay9PBl2ZZ9mOgISEFr
         JUsJMUYJsNbmcrK/KQQHo++lQAPLRGl7zt7QSY6+w0sqo22mq0D3QJ9QG5XJB9bSDvA+
         rLj3atwdta5ENAh7fGUZgowue3Hinnxh6hZEBqTM6G0BY6iClbRaf2Oj44HzQUPZIX7x
         BMd9AByP78/K/TTcBPWnXthqk334/Q6Tk8RX5a6dZXF6rUJmN2efykNx6uAturNO+nEh
         8mKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SEyoGWjUYXqXQWlOLgilVFtItLgtihW+VfcSKV/3elE=;
        b=OTUbQvuODietqzkegdgUJ4B/VLnn+wJn0/09DC/I9Q8eacB2pz6evmQ5YE05Wd092t
         wt0KOscXmTDVpeMd5AXreGe4zVatQ7/huRBp5A2L+f7Md6MOOEWQZ5u69a0aWh8rqUm6
         +QUUrNjWJt4EuPSeGtWFs9DmvgPVBhuKyQgDzD3tUa5kzq/w3dYjJojCj+JrF0n07/Q0
         QvPFHw16PfSiJh+5jduyNsdfiOR3My+jjHz4E3SeGW+jk2ks2OLLWF1O4ewjXZWtCEN0
         R0Z1i9GjtdZzIZcjKGZObv8X03vue2HOHeQikMlNkMcPhiYj2Zjlqw9fbDN0VNJTUvCv
         Fktw==
X-Gm-Message-State: AOAM532OckuIQ15jgnMB8Um/7H5mgm25Ptla3gj9S8kZQuE14lKJWww8
        Ag3b2E0HvYgB8Znie5JJAxKBsmj+OVpzWA==
X-Google-Smtp-Source: ABdhPJxTXc27kXctbVotHeylB1sHitdYMazZYjGmLmhwjHE0eYQ5IsDqExwdtkTxB1Eb0HSbwR4wBQ==
X-Received: by 2002:a05:600c:19c6:: with SMTP id u6mr10000501wmq.154.1627776661933;
        Sat, 31 Jul 2021 17:11:01 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.232.220])
        by smtp.gmail.com with ESMTPSA id c2sm6427873wrs.60.2021.07.31.17.11.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 31 Jul 2021 17:11:01 -0700 (PDT)
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
References: <CADVatmOf+ZfxXA=LBSUqDZApZG3K1Q8GV2N5CR5KgrJLqTGsfg@mail.gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: KASAN: stack-out-of-bounds in iov_iter_revert
Message-ID: <f38b93f3-4cdb-1f9b-bd81-51d32275555e@gmail.com>
Date:   Sun, 1 Aug 2021 01:10:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <CADVatmOf+ZfxXA=LBSUqDZApZG3K1Q8GV2N5CR5KgrJLqTGsfg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/31/21 7:21 PM, Sudip Mukherjee wrote:
> Hi Jens, Pavel,
> 
> We had been running syzkaller on v5.10.y and a "KASAN:
> stack-out-of-bounds in iov_iter_revert" was being reported on it. I
> got some time to check that today and have managed to get a syzkaller
> reproducer. I dont have a C reproducer which I can share but I can use
> the syz-reproducer to reproduce this with v5.14-rc3 and also with
> next-20210730.

Can you try out the diff below? Not a full-fledged fix, but need to
check a hunch.

If that's important, I was using this branch:
git://git.kernel.dk/linux-block io_uring-5.14


diff --git a/fs/io_uring.c b/fs/io_uring.c
index bf548af0426c..fdcd25eca67d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3316,6 +3316,10 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
 		/* no retry on NONBLOCK nor RWF_NOWAIT */
 		if (req->flags & REQ_F_NOWAIT)
 			goto done;
+		if (WARN_ON_ONCE(iter->truncated)) {
+			iov_iter_reexpand(iter, iov_iter_count(iter) + iter->truncated);
+			iter->truncated = 0;
+		}
 		/* some cases will consume bytes even on error returns */
 		iov_iter_revert(iter, io_size - iov_iter_count(iter));
 		ret = 0;
@@ -3455,6 +3459,10 @@ static int io_write(struct io_kiocb *req, unsigned int issue_flags)
 		kiocb_done(kiocb, ret2, issue_flags);
 	} else {
 copy_iov:
+		if (WARN_ON_ONCE(iter->truncated)) {
+			iov_iter_reexpand(iter, iov_iter_count(iter) + iter->truncated);
+			iter->truncated = 0;
+		}
 		/* some cases will consume bytes even on error returns */
 		iov_iter_revert(iter, io_size - iov_iter_count(iter));
 		ret = io_setup_async_rw(req, iovec, inline_vecs, iter, false);
diff --git a/include/linux/uio.h b/include/linux/uio.h
index 82c3c3e819e0..eff06d139fd4 100644
--- a/include/linux/uio.h
+++ b/include/linux/uio.h
@@ -30,6 +30,7 @@ enum iter_type {
 struct iov_iter {
 	u8 iter_type;
 	bool data_source;
+	u16 truncated;
 	size_t iov_offset;
 	size_t count;
 	union {
@@ -254,8 +255,10 @@ static inline void iov_iter_truncate(struct iov_iter *i, u64 count)
 	 * conversion in assignement is by definition greater than all
 	 * values of size_t, including old i->count.
 	 */
-	if (i->count > count)
+	if (i->count > count) {
+		i->truncated += i->count - count;
 		i->count = count;
+	}
 }
 
 /*
@@ -264,6 +267,8 @@ static inline void iov_iter_truncate(struct iov_iter *i, u64 count)
  */
 static inline void iov_iter_reexpand(struct iov_iter *i, size_t count)
 {
+	WARN_ON_ONCE(i->count > count);
+	i->truncated -= count - i->count;
 	i->count = count;
 }
