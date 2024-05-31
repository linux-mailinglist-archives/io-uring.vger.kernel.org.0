Return-Path: <io-uring+bounces-2045-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DE2F68D6C81
	for <lists+io-uring@lfdr.de>; Sat,  1 Jun 2024 00:31:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8AD451F2B062
	for <lists+io-uring@lfdr.de>; Fri, 31 May 2024 22:31:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D613578285;
	Fri, 31 May 2024 22:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="uuXcwyhe"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9A7C20B33
	for <io-uring@vger.kernel.org>; Fri, 31 May 2024 22:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717194658; cv=none; b=GQ2QT5kT8yynUa7v3qK+aExShsUqjmbT455Nmo8d4See23PL9/L7KOuoI9lVgyCG5hhR4JtCODczJ6Jw3mC3hMopfRoKs6uYzEibKk/BlVtI3lfEy+NoSpRVEIeXOhm+hbXcZnBS5Cxbgvvro68VVZHAnyhn79HiXKYYCLDyIt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717194658; c=relaxed/simple;
	bh=3qfcBjt1CAJXE0ms4ESzqfpoWXTVAMwJS5hhQO/l2q0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=grekM+u3W57r5lLIfm1oepP2Lct1iUMq4Mw7jcvzIm1rHE/f69clkhyO7G3gok0dXouk715mWriIXuKvOpU839XJ2ZyQAhgBXYTCEn/ED9HV9Xo+B7BTF+QlMEHAnpHFkxUW4ofRTGralAQPL42yEYEmjErnQE/VSFoONXBFH6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=uuXcwyhe; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-6818d68f852so300603a12.0
        for <io-uring@vger.kernel.org>; Fri, 31 May 2024 15:30:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1717194656; x=1717799456; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WBquctFApHSLduXxKNFvAQ62YyJOYniQ90Vk+ErTq3A=;
        b=uuXcwyhe/uSdVaGbqEY+QilylwTvHV4D7Q4a7sk9bj8SgwPOgtrXOv26kUsYXNy/ul
         n6KuhbbEs+4bRqs/rinmJly2GBR7hXL0Y3b8yWkJQLzuarPgKxK4Vn2qIlMgATND4a8N
         pEzfv3aGEgPv24MvPKLCIAjbWHEituJDdqoK1NCQ4USG0vuK3X94sSV2tOJ4Lyd0heBT
         r0eWAnnvY1ouOY0R0B9yv2umOlU1Qd/y9aeWiVmBZzR/kY8BcZm6+19mmrTDrkhqIPLq
         E26r/CqjbAJnYfddlYhaHY+JVsdueOrt6wiV3Q59gxa0fxsw184V1936Ok/Vd0PHqL5w
         ReIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717194656; x=1717799456;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WBquctFApHSLduXxKNFvAQ62YyJOYniQ90Vk+ErTq3A=;
        b=NxHdEkyE6ys175aQ7ogcOr8kD9GkYnzakqTQ4an0KOOySVD1MA/HQijaeLywH0gA/P
         ruqsfW5IcxOKaxEkjVmtcoeeV4m32ktrA7sYXl+Qu7JYkbrLNSpFE/JwOMbx5FrEdFHO
         VDeMe4oQa3quAXQM+6Dmqanc6JsnM0nBot5AquTboG8KUgzF/mk7QT23Na7tbrNIxZZ+
         JcAepMVh+C/kj4TGwjs+Ctoq1zEhel6ruopAe5lQ4iCgzj5fcQ0J5bDhVJjm4lHh4TNL
         JpqtwMg5PAcDuYVHc8jj2gXQs22SStz4roEN7Or8vHbc0sBTMcb7bKixTefkUTNIuIDL
         Uh2g==
X-Gm-Message-State: AOJu0Yzd7DaHFW4MJeHu2Ifg9MXZJEzNh2DCiiryuMYIXTx94CG+Bd/s
	VHOxcvGy5Akhi6i27CWUMK888cc4b0xS7oEyKbm8pHLEn44560Y6yx2US28RiYI=
X-Google-Smtp-Source: AGHT+IEQ1gUzY28XMmDof7hwAUEtQJp8aSnhKAfEiyQo0il7hiDMcnExiVj5f+ty6z30BlZMcSPfMA==
X-Received: by 2002:a62:e116:0:b0:6ec:ee44:17bb with SMTP id d2e1a72fcca58-70247899e76mr3226431b3a.2.1717194655840;
        Fri, 31 May 2024 15:30:55 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-702516d1fe9sm666670b3a.165.2024.05.31.15.30.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 May 2024 15:30:55 -0700 (PDT)
Message-ID: <b7c714ae-6406-4661-a653-ef1888118d92@kernel.dk>
Date: Fri, 31 May 2024 16:30:54 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/5] io_uring: Introduce IORING_OP_BIND
To: Gabriel Krisman Bertazi <krisman@suse.de>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org
References: <20240531211211.12628-1-krisman@suse.de>
 <20240531211211.12628-5-krisman@suse.de>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240531211211.12628-5-krisman@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/31/24 3:12 PM, Gabriel Krisman Bertazi wrote:
> +int io_bind_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
> +{
> +	struct io_bind *bind = io_kiocb_to_cmd(req, struct io_bind);
> +	struct sockaddr __user *uaddr;
> +	struct io_async_msghdr *io;
> +	int ret;
> +
> +	if (sqe->len || sqe->buf_index || sqe->rw_flags || sqe->splice_fd_in)
> +		return -EINVAL;
> +
> +	uaddr = u64_to_user_ptr(READ_ONCE(sqe->addr));
> +	bind->addr_len =  READ_ONCE(sqe->addr2);
> +
> +	io = io_msg_alloc_async(req);
> +	if (unlikely(!io))
> +		return -ENOMEM;
> +
> +	ret = move_addr_to_kernel(uaddr, bind->addr_len, &io->addr);
> +	if (ret)
> +		io_req_msg_cleanup(req, 0);
> +	return ret;
> +}

As mentioned in the other patch, I think this can just be:

	return move_addr_to_kernel(uaddr, bind->addr_len, &io->addr);
}

and have normal cleanup take care of it.

> +int io_bind(struct io_kiocb *req, unsigned int issue_flags)
> +{
> +	struct io_bind *bind = io_kiocb_to_cmd(req, struct io_bind);
> +	struct io_async_msghdr *io = req->async_data;
> +	int ret;
> +
> +	ret = __sys_bind_socket(sock_from_file(req->file),  &io->addr, bind->addr_len);
> +	if (ret < 0)
> +		req_set_fail(req);
> +	io_req_set_res(req, ret, 0);
> +
> +	return 0;
> +}

Kill the empty line before return.

Outside of those minor nits, patch looks good!

-- 
Jens Axboe


