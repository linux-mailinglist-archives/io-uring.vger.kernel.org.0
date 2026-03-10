Return-Path: <io-uring+bounces-12625-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uHL7OA5JsGnFhgIAu9opvQ
	(envelope-from <io-uring+bounces-12625-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 10 Mar 2026 17:38:38 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 60A74254F44
	for <lists+io-uring@lfdr.de>; Tue, 10 Mar 2026 17:38:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 3884630FF9A9
	for <lists+io-uring@lfdr.de>; Tue, 10 Mar 2026 16:24:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0197D3BF690;
	Tue, 10 Mar 2026 16:24:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="k91FL7Ac"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A561434EEF9
	for <io-uring@vger.kernel.org>; Tue, 10 Mar 2026 16:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773159889; cv=none; b=G2cxqYEFo09PrI3+ACeR5MayLDAXm6Yrcc4VLLEXrdngxshehEptakLKLj/QrwcSbgb8V+2CsIlOkBoPcNHuf2bmablr9Qz0m0gRhkZEIhzDO48Eh8H9UHEpiPTYtrGSj/f0PoewVl8YecKVbxytKIAfYKaWVLXM7DuMgfKg5yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773159889; c=relaxed/simple;
	bh=0j569HX7eBjARrEZdsaQkI5bhoiiEUyfWNqGYVyxY6c=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=N7qoZ2d4uQSanrXh08Fao+Ziv+o03KCu+6PbVm7T/AmqoYgeqw1RQ0CJM8Js/jIEuqSwWl5b9ghvpYpx6svMtHb/NRb4QtJWQ5Mz32TDzKWC3YG8L/HfotxpSB61Iedkj+k/xdJXRai647sXCXdFkqAPYtmGpJroxIsMKsRTg64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=k91FL7Ac; arc=none smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-50335b926c2so115667671cf.2
        for <io-uring@vger.kernel.org>; Tue, 10 Mar 2026 09:24:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1773159886; x=1773764686; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nxg4BN35uYts0MnZI088ckNmGLQAe9LkT0Ot2TrMe0g=;
        b=k91FL7Ac/9ZgthRrMBm2xhXCyXoAvsYmyilLE0V7UcdLkJNEVcGVfYz2Z45oYdHC4A
         QEWkYp7MA1eamsPFdGsS6JsnstZ0KdcZKs69/op07dGW9JFQQJI+SK4D8ptlEgFfUPGP
         DY7cMUneFQWxzORX8PsSKVZWTEZX8NCgOlOqWXQFm0gwBchmd4ZSgLMkLzJNHkdLNhRq
         kc8NJRrf+Pl1CeciSkY86Fm/5wy5utBCnDYs3zQJlSgOFBN9paaAqawPwBbeVhrb6CLe
         sSsNh67hg2M+ZzuR0XMeN+qI8eamY5gC0LVbWai/RDnqXf1DxfRL1ZMKMSHjX+o1h1mY
         9T9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773159886; x=1773764686;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nxg4BN35uYts0MnZI088ckNmGLQAe9LkT0Ot2TrMe0g=;
        b=quMYktbTu0YF+UJPdRFrumb+L6E5/QB25YlDwWjW0BTgdhZk095kz3P83tfvLe+UbQ
         XWq8mOPweo5xU6EWAlEXGDUMIN5QKsUeKDHz/cN2xwJW9WQjXFNp44CyBs0e22zaeenP
         weHBRDsY/vIXcaZel4VKpXAozF10CiAJF5CUiOO6SZOlGb5UUQBbGKQHaBkN/2pE5j8E
         zJN5WXowPKdEu9cqtPqBvv7lFCvUqMp6+RVhvuBjEUOxooE/CocmhQTlvO5Pn2X8AnRN
         j8yngg04klngFC9RFVFAtYF+GBOhk5tvRJtvZrkPxEUVfr9xFkYKmkidaYl+5FNqIdcx
         Z0FA==
X-Forwarded-Encrypted: i=1; AJvYcCW83HTaX/7jP+wY8LSdAmEl2gJ26r+fHXinnKdHXAJkR9c1xCZwJgQHZm+17HrM9kvAkUUTZy8b2Q==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz/YbPIVxia+KHoi61BXLXDR6KAd13G4UIN1UQU2CdsGWaH8jKY
	Dfbd3oSgLmX2eioTslM44F3p/4RGPhEiDfmn48ZdnbdWxVxzkGUqjbvlIdcEFIy/lq4=
X-Gm-Gg: ATEYQzzz2Xg7znpuBQBjJte65eEzPpb/3z83cjL+qJ68zTDdbDNGwlhhffllTUF8Vq7
	ty6v6GNAVJqgwaKN4auj9N8lCtCzaXrf8DVbuQqWp45IGcOCjPc8V8InepZto0FlQSLOeB04Nks
	+zQWcJK3yvPMoF+hM9ouXtE3ruq2SVZczjRC3o3jsiXhKiVEVWyqqcooQjbkfjJcpo120B13gH+
	24fH4ZHaZz7OP0GK5ttV7QF0J9r97olSmccQC2XyrfCX3n5pMROUXxo42g6XvPI3aJonMHVtEDW
	3GQKgFKnXeFlBgDIqYZEcFGdxurx6JWv/4bmZn6E4Q14m96/qrb3OukhcxgFOgeAyVSSzt13b5B
	yfkXO5oiZ10MpJyNvGNRYlsYzcAT6BUHu0OSd8BirC3zV0AhqQGaLX1j0Y5J2+ZctgarKn958KZ
	XF9YcOrshH/3qOdxiQyvqc20a9HX/Hu3qsUBvNHS74g692+2NCcxznJ2K2YvqFzglsN1OZfn7R+
	boorxeTemoIrF18O8k=
X-Received: by 2002:a05:622a:1209:b0:509:2faf:490 with SMTP id d75a77b69052e-5092faf0b85mr24305301cf.11.1773159886549;
        Tue, 10 Mar 2026 09:24:46 -0700 (PDT)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-508f6695614sm94992321cf.22.2026.03.10.09.24.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Mar 2026 09:24:45 -0700 (PDT)
Message-ID: <c29a339d-67c5-4e8a-a1c9-2388aa9f28d5@kernel.dk>
Date: Tue, 10 Mar 2026 10:24:40 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: Add IORING_OP_DUP
To: Daniele Di Proietto <daniele.di.proietto@gmail.com>,
 io-uring@vger.kernel.org
References: <20260310154933.2500971-1-daniele.di.proietto@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260310154933.2500971-1-daniele.di.proietto@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 60A74254F44
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12625-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	FREEMAIL_TO(0.00)[gmail.com,vger.kernel.org];
	DMARC_NA(0.00)[kernel.dk];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,kernel-dk.20230601.gappssmtp.com:dkim,kernel.dk:mid]
X-Rspamd-Action: no action

On 3/10/26 9:49 AM, Daniele Di Proietto wrote:
> The new operation is like dup3(). The source file can be a regular file
> descriptor or a direct descriptor. The destination is a regular file
> descriptor.
> 
> The direct descriptor variant is useful to move a descriptor to an fd
> and close the existing fd with a single acquisition of the `struct
> files_struct` `file_lock`. Combined with IORING_OP_ACCEPT or
> IORING_OP_OPENAT2 with direct descriptors, it can reduce lock contention
> for multithreaded applications.

Overall comment - how does this interact with direct descriptors? Feels
like this should support both, rather than just normal file descriptors.

> @@ -446,3 +452,46 @@ int io_pipe(struct io_kiocb *req, unsigned int issue_flags)
>  		fput(files[1]);
>  	return ret;
>  }
> +
> +int io_dup_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
> +{
> +	unsigned int flags;
> +	struct io_dup *id;
> +	int new_fd;
> +
> +	if (sqe->off || sqe->addr || sqe->len || sqe->buf_index || sqe->addr3)
> +		return -EINVAL;
> +
> +	flags = READ_ONCE(sqe->dup_flags);
> +	if (flags & ~IORING_DUP_NO_CLOEXEC)
> +		return -EINVAL;
> +
> +	new_fd = READ_ONCE(sqe->dup_new_fd);
> +	if (new_fd < 0)
> +		return -EBADF;

Is this necessary? Yes it'll help fail early, but do we care about that?

> +	/* ensure the task's creds are used when installing/receiving fds */
> +	if (req->flags & REQ_F_CREDS)
> +		return -EPERM;

Not sure that's sane. Let's say you mark this request as IOSQE_ASYNC,
then it'd fail even if REQ_F_CREDS would then be set, and creds would
match the original task.


> +
> +	id = io_kiocb_to_cmd(req, struct io_dup);
> +	id->o_flags = O_CLOEXEC;
> +	if (flags & IORING_DUP_NO_CLOEXEC)
> +		id->o_flags = 0;
> +	id->new_fd = new_fd;
> +
> +	return 0;
> +}
> +
> +int io_dup(struct io_kiocb *req, unsigned int issue_flags)
> +{
> +	struct io_dup *id;
> +	int ret;
> +
> +	id = io_kiocb_to_cmd(req, struct io_dup);
> +	ret = replace_fd(id->new_fd, id->file, id->o_flags);
> +	if (ret < 0)
> +		req_set_fail(req);
> +	io_req_set_res(req, ret, 0);
> +	return IOU_COMPLETE;

And like Keith said here, we might need to punt it to io-wq if the file
has a ->flush() method.

-- 
Jens Axboe

