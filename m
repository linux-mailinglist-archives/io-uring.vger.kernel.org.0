Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36FDC3DCAD2
	for <lists+io-uring@lfdr.de>; Sun,  1 Aug 2021 10:52:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbhHAIxC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 1 Aug 2021 04:53:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229885AbhHAIxC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 1 Aug 2021 04:53:02 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 719DEC06175F;
        Sun,  1 Aug 2021 01:52:53 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id k4so8572801wms.3;
        Sun, 01 Aug 2021 01:52:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:references:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3ntFFUEJHJ5MJEqHglVW9TCArN6M1xRMeieVLDZYfos=;
        b=hJ6JH0gCzDGS1MrnPCscTeCpmfb6Li55vIOs0sEBdTveTG2Kk/02VUBcTTD6LCUJMF
         +UUr3VU/2mMB8B+eEn0z1h4MSdlOo9aCNkBqBdpdDX2eX79iIK0B/V83DCz4exSjIQd9
         XQxmU/99mG1c2fgMDHhqI5R9GpltCg9oRh4eBIeYu2HlXxczCAzOHWkKh26Zt1kKdsLP
         /SNcTJISpzJU2ky7S8JEFD4SbIBQmSIHVV8GHZ66JIi4m5Q0n729vseVzxzBO5VK3fdy
         0rMw63VOQ50Xiw5WBuplDjO5EHTIFtWg9mdmDSx+Vey9I28Sad5fc5YVsGObieiOqHfY
         0vGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:references:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3ntFFUEJHJ5MJEqHglVW9TCArN6M1xRMeieVLDZYfos=;
        b=srd3xJpokqRfm7C9PZT756a+kOFM0Fl2bujAlYyLwWktGVbu6QGb3MNCBYaZadQ81B
         rg+tYvMsFoNVXlfNsEuRy0hUVALQr/aeZUa5VJBsp+LH2nyKhlsJQwnLBLZCBgx3R8W7
         xp1eHQvL76zt1aF+H/oHHqwSU9QrLlCx1yv69bnpd6/pPoz0Kpn4HzkgrCgmaYeIeTpC
         y29om7OpxhcPM902Z58fYxm7c+OSVQYLWF6lYBO5hCTGv78iVAalQpVzvkJ2e8FEx1fl
         hfydr/KJaS6tvUHhCEk0C0IHKnp3+45XZmevNCPbHSRtMeYpBH63N3DwRYgse4YxOuz5
         LtEw==
X-Gm-Message-State: AOAM533NvI1lZhbmHWqJ3O4SRJQcIjXgrQhx45nH81IBo4ifjQ+qckrn
        tblo5Z6NWHM5kmktTuxqEclfRJ8UkCvBjg==
X-Google-Smtp-Source: ABdhPJxryPAOk+H33xMnXFatjMlvm3y58+pkv8wvmLid4mLqFhosRp0QU/xr+yQD8nCYkHE+FxlmMw==
X-Received: by 2002:a7b:c5c7:: with SMTP id n7mr11642922wmk.5.1627807971842;
        Sun, 01 Aug 2021 01:52:51 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.232.220])
        by smtp.gmail.com with ESMTPSA id w18sm7673558wrg.68.2021.08.01.01.52.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 Aug 2021 01:52:51 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
References: <CADVatmOf+ZfxXA=LBSUqDZApZG3K1Q8GV2N5CR5KgrJLqTGsfg@mail.gmail.com>
 <f38b93f3-4cdb-1f9b-bd81-51d32275555e@gmail.com>
Subject: Re: KASAN: stack-out-of-bounds in iov_iter_revert
Message-ID: <4c339bea-87ff-cb41-732f-05fc5aff18fa@gmail.com>
Date:   Sun, 1 Aug 2021 09:52:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <f38b93f3-4cdb-1f9b-bd81-51d32275555e@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/1/21 1:10 AM, Pavel Begunkov wrote:
> On 7/31/21 7:21 PM, Sudip Mukherjee wrote:
>> Hi Jens, Pavel,
>>
>> We had been running syzkaller on v5.10.y and a "KASAN:
>> stack-out-of-bounds in iov_iter_revert" was being reported on it. I
>> got some time to check that today and have managed to get a syzkaller
>> reproducer. I dont have a C reproducer which I can share but I can use
>> the syz-reproducer to reproduce this with v5.14-rc3 and also with
>> next-20210730.
> 
> Can you try out the diff below? Not a full-fledged fix, but need to
> check a hunch.
> 
> If that's important, I was using this branch:
> git://git.kernel.dk/linux-block io_uring-5.14

Or better this one, just in case it ooopses on warnings.

diff --git a/fs/io_uring.c b/fs/io_uring.c
index bf548af0426c..12284616854b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3316,6 +3316,11 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
 		/* no retry on NONBLOCK nor RWF_NOWAIT */
 		if (req->flags & REQ_F_NOWAIT)
 			goto done;
+		if (iter->truncated) {
+			printk("truncated rd: %i\n", (int)iter->truncated);
+			iov_iter_reexpand(iter, iov_iter_count(iter) + iter->truncated);
+			iter->truncated = 0;
+		}
 		/* some cases will consume bytes even on error returns */
 		iov_iter_revert(iter, io_size - iov_iter_count(iter));
 		ret = 0;
@@ -3455,6 +3460,11 @@ static int io_write(struct io_kiocb *req, unsigned int issue_flags)
 		kiocb_done(kiocb, ret2, issue_flags);
 	} else {
 copy_iov:
+		if (iter->truncated) {
+			printk("truncated wr: %i\n", (int)iter->truncated);
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
 

