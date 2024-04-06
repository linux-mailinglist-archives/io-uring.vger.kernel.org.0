Return-Path: <io-uring+bounces-1432-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B9A8989ACF7
	for <lists+io-uring@lfdr.de>; Sat,  6 Apr 2024 22:58:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 27689B20BDD
	for <lists+io-uring@lfdr.de>; Sat,  6 Apr 2024 20:58:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1CE43BB27;
	Sat,  6 Apr 2024 20:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iHHSC1xV"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3226933CF5
	for <io-uring@vger.kernel.org>; Sat,  6 Apr 2024 20:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712437101; cv=none; b=XX16KjxFvbQNCKv0s7IIaB1emQHG5+7qTSNjwk0L9syj18cTNB13ffVV7SWinwtvBqz/kJkiB5rNNbVl4Do9Fg2HqEsv7jCVSyCWlAtViD6Y4twprD/54taHGL73Rnd+Vfi8qIu+ycytIKDvmocp1HUHhMVWXVV6mkpkEYG6mwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712437101; c=relaxed/simple;
	bh=QZHitEPDWBsyqj8M3r+gCLTyow/lC3S13TtkhFDPZSo=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=XZaijzFphFJGEc5q+lf0XI+GeDybdEbQ13LtqESuPU7UORUdAJ3fh57npHun3ISpP+R2MkgZEPcgrA0o1ofaS+fZO4uKyTC8GSTnusa790q/LEq0AK2aXmhqr+2LDJQ2E8aw3K9JmxKRSd+THj9+q/+swL2ZKNsYaISmYBCKIf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iHHSC1xV; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-34388753650so1419777f8f.3
        for <io-uring@vger.kernel.org>; Sat, 06 Apr 2024 13:58:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712437098; x=1713041898; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lTxBzvYKFesUhd8w2IKbIdRA2hHr0RAvSHmC1aaZSzk=;
        b=iHHSC1xVM0zpXRpn1D7hlzloZuUjnycObh2Tu0NuzVnJlGrVHnXRejQooEGs17SF+a
         OJZvuJ+wsW2iNdvs1jD4xSXPY+QEZm2hPDl+M4CvYW9VGa99fgFe3+tWE3P778GjSgVl
         KpKRKNiC/oZUZbILCRqJbSECHYq9fw5MO9o9hpq9UaGJsQqPw8E7y04TWDmOGIruswvb
         Py4EKHe65YL/Eb9OP/oGl6ImqV3bez+QeTLlkBnHlv48J9duLcdI8daMEN32DA2ZWq9H
         OyehvrpLPVZlc7cmIlQfcDragVoiIIgjxiI+bkLsaQ37oNQ0i8AT7j+XjpAQlT7GcHGG
         Ocpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712437098; x=1713041898;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lTxBzvYKFesUhd8w2IKbIdRA2hHr0RAvSHmC1aaZSzk=;
        b=YxBGFDZqFGdDWRuBLeHLJVra494gnjckI8gk5FtaBFuLqWhrjPBM/Zq/mFv95aqAEt
         GuSRN9nZmseYyAdNhbOMH7Am3nCdp1Wb7Vg8xtjfGTUGvlbVytNH8QBM/r7R/3pYliwD
         4eBCcjpRzBnASSc7UG43mxzshCQJ9SfyrB8sWjRZcXn5LEQpKlaa7LeRhLS4zvihbP0d
         UXjeOJG9NS69r9gYWkhYI5MFy1ve+b9iyB8IOX335T1NhEM8GazZBPjrMDUJ3lHuSnuS
         HfQwzOH7FfKkEPVgGX7Y0y3lSp6LUtUKq8RZNqBSgP7rUJz2Kv3I2EhO6vSuKtX9SFJS
         b4Gg==
X-Forwarded-Encrypted: i=1; AJvYcCVz+qrkYGVW8RySfTYsMwpN3/Inq2MgJa9US77c9F0wkNTw8p9RrIfAOMWSv2x/DnBm1acuavIWfqO+7lnJf3R7OJi5evxSXY4=
X-Gm-Message-State: AOJu0YwBxnpY9cHmIuLO3aLl6fixwhdiiuWhoT2vz5c2SZE7aZlTCdra
	yFM/5BJFERIa/Olb2KBfQ1McmFmtx4VX/JiLodlTI/NW5G2T1apx2xguzoVw
X-Google-Smtp-Source: AGHT+IELeV1Vgjny39d38n5SkBezsD7T+T0Sp0YXABmQ9FbzwqB1182wetYAmyoONBdlQi1W/7uDsg==
X-Received: by 2002:adf:cc87:0:b0:341:7864:a6e3 with SMTP id p7-20020adfcc87000000b003417864a6e3mr3436374wrj.2.1712437098366;
        Sat, 06 Apr 2024 13:58:18 -0700 (PDT)
Received: from [192.168.42.178] ([85.255.235.79])
        by smtp.gmail.com with ESMTPSA id e16-20020adff350000000b00343ca138924sm5206697wrp.39.2024.04.06.13.58.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 06 Apr 2024 13:58:17 -0700 (PDT)
Message-ID: <ec05edbe-0459-4549-a94b-cf4b17f2464d@gmail.com>
Date: Sat, 6 Apr 2024 21:58:17 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/17] io_uring/net: switch io_send() and io_send_zc() to
 using io_async_msghdr
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <20240320225750.1769647-1-axboe@kernel.dk>
 <20240320225750.1769647-2-axboe@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20240320225750.1769647-2-axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/20/24 22:55, Jens Axboe wrote:
> No functional changes in this patch, just in preparation for carrying
> more state then we have now, if necessary. While unifying some of this
> code, add a generic send setup prep handler that they can both use.
> 
> This gets rid of some manual msghdr and sockaddr on the stack, and makes
> it look a bit more like the sendmsg/recvmsg variants. We can probably
> unify a bit more on top of this going forward.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>   io_uring/net.c   | 196 ++++++++++++++++++++++++-----------------------
>   io_uring/opdef.c |   1 +
>   2 files changed, 103 insertions(+), 94 deletions(-)
> 
> diff --git a/io_uring/net.c b/io_uring/net.c
> index ed798e185bbf..a16838c0c837 100644
> --- a/io_uring/net.c
> +++ b/io_uring/net.c
> @@ -322,36 +322,25 @@ static int io_sendmsg_copy_hdr(struct io_kiocb *req,
>  
...
> -int io_send(struct io_kiocb *req, unsigned int issue_flags)
> +static struct io_async_msghdr *io_send_setup(struct io_kiocb *req,
> +					     struct io_async_msghdr *stack_msg,
> +					     unsigned int issue_flags)
>   {
> -	struct sockaddr_storage __address;
>   	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
> -	struct msghdr msg;
> -	struct socket *sock;
> -	unsigned flags;
> -	int min_ret = 0;
> +	struct io_async_msghdr *kmsg;
>   	int ret;
>   
> -	msg.msg_name = NULL;
> -	msg.msg_control = NULL;
> -	msg.msg_controllen = 0;
> -	msg.msg_namelen = 0;
> -	msg.msg_ubuf = NULL;
> -
> -	if (sr->addr) {
> -		if (req_has_async_data(req)) {
> -			struct io_async_msghdr *io = req->async_data;
> -
> -			msg.msg_name = &io->addr;
> -		} else {
> -			ret = move_addr_to_kernel(sr->addr, sr->addr_len, &__address);
> +	if (req_has_async_data(req)) {
> +		kmsg = req->async_data;
> +	} else {
> +		kmsg = stack_msg;
> +		kmsg->free_iov = NULL;
> +		kmsg->msg.msg_name = NULL;
> +		kmsg->msg.msg_namelen = 0;
> +		kmsg->msg.msg_control = NULL;
> +		kmsg->msg.msg_controllen = 0;
> +		kmsg->msg.msg_ubuf = NULL;
> +
> +		if (sr->addr) {
> +			ret = move_addr_to_kernel(sr->addr, sr->addr_len,
> +						  &kmsg->addr);
>   			if (unlikely(ret < 0))
> -				return ret;
> -			msg.msg_name = (struct sockaddr *)&__address;
> +				return ERR_PTR(ret);
> +			kmsg->msg.msg_name = &kmsg->addr;
> +			kmsg->msg.msg_namelen = sr->addr_len;
> +		}
> +
> +		if (!io_do_buffer_select(req)) {

it seems, this chunk leaked from another series as well. fwiw,
it was moved in a later commit
"io_uring/net: get rid of ->prep_async() for send side"



> +			ret = import_ubuf(ITER_SOURCE, sr->buf, sr->len,
> +					  &kmsg->msg.msg_iter);
> +			if (unlikely(ret))
> +				return ERR_PTR(ret);
>   		}
> -		msg.msg_namelen = sr->addr_len;
>   	}
-- 
Pavel Begunkov

