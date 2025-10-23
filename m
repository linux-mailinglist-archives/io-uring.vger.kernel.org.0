Return-Path: <io-uring+bounces-10162-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 19580C03070
	for <lists+io-uring@lfdr.de>; Thu, 23 Oct 2025 20:38:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 913543ACCFF
	for <lists+io-uring@lfdr.de>; Thu, 23 Oct 2025 18:38:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6EC626F2AC;
	Thu, 23 Oct 2025 18:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="zTJ7hVBd"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D21E52367CE
	for <io-uring@vger.kernel.org>; Thu, 23 Oct 2025 18:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761244677; cv=none; b=hfkkmokgQxIq0IUv6mGXpd5X5WuwO+206ekscz+lfPKOEiQr7YdgkAmq4/SpcZIJP8SSQl6AtgeSDPUknZrbRkn+EJCXq8UQ9Z6nxQimcJhspXvbzIYi9Yf2slT7pASJ5fXYep3ewbRxVjqx/Rg3yoizYzDC81+VyJ0DFSO8Amk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761244677; c=relaxed/simple;
	bh=b+/M0hqKIDVy7BjSmgKLVDO9HXo9HHdSD6L0Znlz7Vw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=O5Q9wxuit23DgEPSQ7Dw39kk2cb02nTrvOCPs3U4i052VV8U31T5PrIXGbZ3l2lRWsa35gnjLn/Hsz0CsJ7ydQBQQqKMyKy6kylVMATGBZgehnUQpLDEwHO4orvSAc8jXb+oUZFMg9wIeN3yJpwYAFM07MDx43PTTdxg7DTJvqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=zTJ7hVBd; arc=none smtp.client-ip=209.85.166.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-940d92d6962so44283639f.3
        for <io-uring@vger.kernel.org>; Thu, 23 Oct 2025 11:37:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1761244672; x=1761849472; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+gIUFgvmxXF65aZwN/tyCOa4UkQp8aWYHn445IWaoLM=;
        b=zTJ7hVBdy7jEeplnZ9U9xe3tT2nIl6fj5yUOnw9fNFN/Kb1SKO3G057ZyRERUKaLhl
         tDXG/6WLqvPf1eH9rcctwFo/Y50x2GXjQ7jX9h6sSzsrd/H4dMfxvum67drEYunKzUEf
         K23bc1BcpYvrVr8mHmMvKEzmGmxgsDqvMn/fbz5WPfFER+TZJGRvTo+TMSZm2CYVUrVp
         Is7s7V34wQnneri4SY1rDrCIa2Tb4DI4GhxzrXBj/gzEjn4qYpYigEK4tmDYVuvzzyFo
         0dtW2CSL9fbkaBnQAUvaKmXioUuboDhjiCFLE7cvhDJ5OcxKp5x60/46QVJOhJ+nqIK9
         i6kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761244672; x=1761849472;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+gIUFgvmxXF65aZwN/tyCOa4UkQp8aWYHn445IWaoLM=;
        b=tmp+8R+O/QnxBA/Y3sKYT1/6J0UsN1ngQuQYOF59+aetVTMQifVZhxuCxNSISjO7WL
         93phZ8zoPS5uwt9qVAmtQxcvtvt2YZ7qdCl2iiCoaw6+6C0EBXMBsrpKAQmEIS5SedNY
         ytkj39aShn/ZLsCzIP83V2vRNC+X39gVb6+6+j0p5SVZTzWfgVD1zPF+FTAPg9d8TLaj
         8hjo0C+PUP0Rp2PTs+OpcBazrWuzp8tdVIaatRdXIldp9MLYsuKQOR7Lz5w2t5hu0Idh
         pxmSbXo3aZ2LcRLa3ZBbuqe4ymT8EblO2PvGf2Z4wVOag/uDmeS70Xsf31YlX/pU06XB
         ghYA==
X-Forwarded-Encrypted: i=1; AJvYcCWWmvEndnt4pC4xSvqU3CFd8KZ4pFydi1KTIJ9u6q5oisWcnzf6oxumrm2LV029TuoOtRQaZGbu/A==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz76aTldf206nnPeveyHNkSrLYJvc1fwTCx6S1m5dMWhvcamBUe
	VLHqx0P7Z7qq+bFMzExTcktAlt2f2NhJsyO+gkibVdw1T8OdQ3qfCUUlcHl0oJK170E=
X-Gm-Gg: ASbGncsO8Yz+iE1fsibW/W1DAoXqubLYT3TW+FGF7FKfnC/9w6CP6gFkOaSadGz1SUV
	TMYoVck4USlXg0GZq8lBnOurhTG6RFmIiUs2kNUV35Z9IGUIW0rUikVI1apwsqSsCpdM5aRmybP
	Tb2FEwyOCxcJVqpPzrUPgIMMnqfhYVJYNZuS50gPkoSjpde0z2KSxj+cJ81LlC1kWBzTc41rf7I
	D61OmXISRjXiUCKGqt82o5ajSokQI/SB5+BPptkYnlEQiUaZWpUXkEbYpOpr/vqBjmwoHj7MQsn
	uedbtIU91PxFQetifTEsQjGYIg/2Xf6axcQFbP2LaP8/bHVEOnOoLhkedytkszZo6mFYIDbKkRs
	hQX1/KatpgblvwBtWpR/+oXxyJdAF0C4aX2aHQwlrmdM0PzhPwuFmjCFrIbR2agVlanDZwWylPg
	2aNqKmk7A=
X-Google-Smtp-Source: AGHT+IErOPEQNDbGjKe0jK3bG3J0edJN7PqLzZYZdug0+3IvdYcgUVkEMSEMW2hj4FTz1J7Q5clBPQ==
X-Received: by 2002:a05:6602:2d90:b0:940:da3b:6ad4 with SMTP id ca18e2360f4ac-940da3b7674mr2430445139f.13.1761244671747;
        Thu, 23 Oct 2025 11:37:51 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-94102dac064sm101644739f.6.2025.10.23.11.37.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Oct 2025 11:37:50 -0700 (PDT)
Message-ID: <7de9ec55-0217-4c42-b43d-257bcaf11080@kernel.dk>
Date: Thu, 23 Oct 2025 12:37:49 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: fix buffer auto-commit for multishot uring_cmd
To: Ming Lei <ming.lei@redhat.com>, io-uring@vger.kernel.org
Cc: Caleb Sander Mateos <csander@purestorage.com>
References: <20251023104350.2515079-1-ming.lei@redhat.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20251023104350.2515079-1-ming.lei@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/23/25 4:43 AM, Ming Lei wrote:
> Commit 620a50c92700 ("io_uring: uring_cmd: add multishot support") added
> multishot uring_cmd support with explicit buffer upfront commit via
> io_uring_mshot_cmd_post_cqe(). However, the buffer selection path in
> io_ring_buffer_select() was auto-committing buffers for non-pollable files,
> which conflicts with uring_cmd's explicit upfront commit model.
> 
> This way consumes the whole selected buffer immediately, and causes
> failure on the following buffer selection.
> 
> Fix this by adding io_commit_kbuf_upfront() to identify operations that
> handle buffer commit explicitly (currently only IORING_OP_URING_CMD),
> and skip auto-commit for these operations.
> 
> Cc: Caleb Sander Mateos <csander@purestorage.com>
> Fixes: 620a50c92700 ("io_uring: uring_cmd: add multishot support")
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  io_uring/kbuf.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
> index aad655e38672..e3f3dec8b135 100644
> --- a/io_uring/kbuf.c
> +++ b/io_uring/kbuf.c
> @@ -155,6 +155,12 @@ static int io_provided_buffers_select(struct io_kiocb *req, size_t *len,
>  	return 1;
>  }
>  
> +/* So far, uring_cmd commits kbuf upfront, no need to auto-commit */
> +static bool io_commit_kbuf_upfront(const struct io_kiocb *req)
> +{
> +	return req->opcode == IORING_OP_URING_CMD;
> +}
> +
>  static struct io_br_sel io_ring_buffer_select(struct io_kiocb *req, size_t *len,
>  					      struct io_buffer_list *bl,
>  					      unsigned int issue_flags)
> @@ -181,7 +187,8 @@ static struct io_br_sel io_ring_buffer_select(struct io_kiocb *req, size_t *len,
>  	sel.buf_list = bl;
>  	sel.addr = u64_to_user_ptr(buf->addr);
>  
> -	if (issue_flags & IO_URING_F_UNLOCKED || !io_file_can_poll(req)) {
> +	if (issue_flags & IO_URING_F_UNLOCKED || (!io_file_can_poll(req) &&
> +				!io_commit_kbuf_upfront(req))) {
>  		/*
>  		 * If we came in unlocked, we have no choice but to consume the
>  		 * buffer here, otherwise nothing ensures that the buffer won't

Might be cleaner to put this logic in a helper instead, ala:

static bool io_should_commit(req, issue_flags)
{
	if (issue_flags & IO_URING_F_UNLOCKED)
		return true;
	if (!io_file_can_poll(req) && req->opcode == IORING_OP_URING_CMD)
		return true;
	return false;
}

and just add the appropriate comments there, rather than add a new
random helper.

-- 
Jens Axboe

