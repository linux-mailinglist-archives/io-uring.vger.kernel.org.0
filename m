Return-Path: <io-uring+bounces-2055-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E00458D70D9
	for <lists+io-uring@lfdr.de>; Sat,  1 Jun 2024 17:22:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 46F53B21330
	for <lists+io-uring@lfdr.de>; Sat,  1 Jun 2024 15:22:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF8B5152E04;
	Sat,  1 Jun 2024 15:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=s.muenzel.net header.i=@s.muenzel.net header.b="pWBQe7Fj"
X-Original-To: io-uring@vger.kernel.org
Received: from out-185.mta1.migadu.com (out-185.mta1.migadu.com [95.215.58.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF729111AD
	for <io-uring@vger.kernel.org>; Sat,  1 Jun 2024 15:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717255347; cv=none; b=Ln8OfZ9XXSsaB/pU5ebCvXTpFAbv/QLgIX6krFfyOAqvJ8k9dbsd3a1VdMOthoba/p/uQhPBnAQfCvJSMa8dpUi4KGzgCu1kYd2TFK9zCZBjcoxDN1js10klZhGc2va4kmRJrDFcZW1gvHy8tj2xU8hvFvYsoextHUqsHUD5ai4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717255347; c=relaxed/simple;
	bh=GDcLpmoeuWZcKbaWVzHcQU+kSGo90HcjueVVlY1fkPA=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=o3VP5vDKGemLW8VRB6Ysn8qfUZTJaNoEa695YkrYQfLa5kYMVoYftPkUmwCO4SKhbEZ6PovAGTFwLIEQEBhRqO1J4aMj197oEJbZ0Zo0Ui88Wwg4M1hSeCoZ6HsDnn2N9Xye9qaWxd2mv5tIn0XmZeWGlyn9h54d92FuCgl+6GM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=s.muenzel.net; spf=pass smtp.mailfrom=s.muenzel.net; dkim=pass (1024-bit key) header.d=s.muenzel.net header.i=@s.muenzel.net header.b=pWBQe7Fj; arc=none smtp.client-ip=95.215.58.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=s.muenzel.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=s.muenzel.net
X-Envelope-To: axboe@kernel.dk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=s.muenzel.net;
	s=default; t=1717255343;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zvye7KAKaFaHn0c/lIK1OSqg2bhVZSi3XY8vIv3HQoA=;
	b=pWBQe7FjHt31JTNAWxb5cYO0xKX6giBYVojEDhBztwx8UAWsVZ26eQZF/A9As0Rrp6l4PM
	2R8xvL0/FsMe2vPUeIGEoDGmQWq/fuIfS7DZSq6kewevx8l9NfB2rQiFA9loSRgVp57tH1
	Bsdqaz4L5Sve3ESeyuZl89mUysn1/rI=
X-Envelope-To: io-uring@vger.kernel.org
Message-ID: <c9059b69-96d0-45e6-8d05-e44298d7548e@s.muenzel.net>
Date: Sat, 1 Jun 2024 17:22:33 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: madvise/fadvise 32-bit length
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <bc92a2fa-4400-4c3a-8766-c2e346113ea7@s.muenzel.net>
 <db4d32d6-cc71-4903-92cf-b1867b8c7d12@kernel.dk>
 <2d4d3434-401c-42c2-b450-40dec4689797@kernel.dk>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Stefan <source@s.muenzel.net>
In-Reply-To: <2d4d3434-401c-42c2-b450-40dec4689797@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

On 1/6/2024 17:05, Jens Axboe wrote:
> On 6/1/24 8:19 AM, Jens Axboe wrote:
>> On 6/1/24 3:43 AM, Stefan wrote:
>>> io_uring uses the __u32 len field in order to pass the length to
>>> madvise and fadvise, but these calls use an off_t, which is 64bit on
>>> 64bit platforms.
>>>
>>> When using liburing, the length is silently truncated to 32bits (so
>>> 8GB length would become zero, which has a different meaning of "until
>>> the end of the file" for fadvise).
>>>
>>> If my understanding is correct, we could fix this by introducing new
>>> operations MADVISE64 and FADVISE64, which use the addr3 field instead
>>> of the length field for length.
>>
>> We probably just want to introduce a flag and ensure that older stable
>> kernels check it, and then use a 64-bit field for it when the flag is
>> set.
> 
> I think this should do it on the kernel side, as we already check these
> fields and return -EINVAL as needed. Should also be trivial to backport.
> Totally untested... Might want a FEAT flag for this, or something where
> it's detectable, to make the liburing change straight forward.
> 
> 
> diff --git a/io_uring/advise.c b/io_uring/advise.c
> index 7085804c513c..cb7b881665e5 100644
> --- a/io_uring/advise.c
> +++ b/io_uring/advise.c
> @@ -17,14 +17,14 @@
>   struct io_fadvise {
>   	struct file			*file;
>   	u64				offset;
> -	u32				len;
> +	u64				len;
>   	u32				advice;
>   };
>   
>   struct io_madvise {
>   	struct file			*file;
>   	u64				addr;
> -	u32				len;
> +	u64				len;
>   	u32				advice;
>   };
>   
> @@ -33,11 +33,13 @@ int io_madvise_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>   #if defined(CONFIG_ADVISE_SYSCALLS) && defined(CONFIG_MMU)
>   	struct io_madvise *ma = io_kiocb_to_cmd(req, struct io_madvise);
>   
> -	if (sqe->buf_index || sqe->off || sqe->splice_fd_in)
> +	if (sqe->buf_index || sqe->splice_fd_in)
>   		return -EINVAL;
>   
>   	ma->addr = READ_ONCE(sqe->addr);
> -	ma->len = READ_ONCE(sqe->len);
> +	ma->len = READ_ONCE(sqe->off);
> +	if (!ma->len)
> +		ma->len = READ_ONCE(sqe->len);
>   	ma->advice = READ_ONCE(sqe->fadvise_advice);
>   	req->flags |= REQ_F_FORCE_ASYNC;
>   	return 0;
> @@ -78,11 +80,13 @@ int io_fadvise_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>   {
>   	struct io_fadvise *fa = io_kiocb_to_cmd(req, struct io_fadvise);
>   
> -	if (sqe->buf_index || sqe->addr || sqe->splice_fd_in)
> +	if (sqe->buf_index || sqe->splice_fd_in)
>   		return -EINVAL;
>   
>   	fa->offset = READ_ONCE(sqe->off);
> -	fa->len = READ_ONCE(sqe->len);
> +	fa->len = READ_ONCE(sqe->addr);
> +	if (!fa->len)
> +		fa->len = READ_ONCE(sqe->len);
>   	fa->advice = READ_ONCE(sqe->fadvise_advice);
>   	if (io_fadvise_force_async(fa))
>   		req->flags |= REQ_F_FORCE_ASYNC;
> 


If we want to have the length in the same field in both *ADVISE 
operations, we can put a flag in splice_fd_in/optlen.
Maybe the explicit flag is a bit clearer for users of the API
compared to the implicit flag when setting sqe->len to zero?


diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 994bf7af0efe..70794ac1471e 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -415,6 +415,14 @@ enum io_uring_msg_ring_flags {
   */
  #define IORING_NOP_INJECT_RESULT	(1U << 0)

+/*
+ * IORING_OP_FADVISE and IORING_OP_MADVISE flags (stored in sqe->optlen)
+ *
+ * IORING_ADVISE_LEN64          Use 64-bit length stored in sqe->addr3
+ *
+ */
+#define IORING_ADVISE_LEN64		(1U << 0)
+
  /*
   * IO completion data structure (Completion Queue Entry)
   */
diff --git a/io_uring/advise.c b/io_uring/advise.c
index 7085804c513c..f229c751adbc 100644
--- a/io_uring/advise.c
+++ b/io_uring/advise.c
@@ -17,14 +17,14 @@
  struct io_fadvise {
  	struct file			*file;
  	u64				offset;
-	u32				len;
+	u64				len;
  	u32				advice;
  };

  struct io_madvise {
  	struct file			*file;
  	u64				addr;
-	u32				len;
+	u64				len;
  	u32				advice;
  };

@@ -32,12 +32,26 @@ int io_madvise_prep(struct io_kiocb *req, const 
struct io_uring_sqe *sqe)
  {
  #if defined(CONFIG_ADVISE_SYSCALLS) && defined(CONFIG_MMU)
  	struct io_madvise *ma = io_kiocb_to_cmd(req, struct io_madvise);
+	u32 flags;

-	if (sqe->buf_index || sqe->off || sqe->splice_fd_in)
+	if (sqe->buf_index || sqe->off)
  		return -EINVAL;

+	flags = READ_ONCE(sqe->optlen);
+
+	if (flags & ~IORING_ADVISE_LEN64)
+		return -EINVAL;
+
+	if (flags & IORING_ADVISE_LEN64) {
+		if (sqe->len)
+			return -EINVAL;
+
+		ma->len = READ_ONCE(sqe->addr3);
+	} else {
+		ma->len = READ_ONCE(sqe->len);
+	}
+
  	ma->addr = READ_ONCE(sqe->addr);
-	ma->len = READ_ONCE(sqe->len);
  	ma->advice = READ_ONCE(sqe->fadvise_advice);
  	req->flags |= REQ_F_FORCE_ASYNC;
  	return 0;
@@ -77,12 +91,26 @@ static bool io_fadvise_force_async(struct io_fadvise 
*fa)
  int io_fadvise_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
  {
  	struct io_fadvise *fa = io_kiocb_to_cmd(req, struct io_fadvise);
+	u32 flags;

-	if (sqe->buf_index || sqe->addr || sqe->splice_fd_in)
+	if (sqe->buf_index || sqe->addr)
  		return -EINVAL;

+	flags = READ_ONCE(sqe->optlen);
+
+	if (flags & ~IORING_ADVISE_LEN64)
+		return -EINVAL;
+
+	if (flags & IORING_ADVISE_LEN64) {
+		if (sqe->len)
+			return -EINVAL;
+
+		fa->len = READ_ONCE(sqe->addr3);
+	} else {
+		fa->len = READ_ONCE(sqe->len);
+	}
+
  	fa->offset = READ_ONCE(sqe->off);
-	fa->len = READ_ONCE(sqe->len);
  	fa->advice = READ_ONCE(sqe->fadvise_advice);
  	if (io_fadvise_force_async(fa))
  		req->flags |= REQ_F_FORCE_ASYNC;


