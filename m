Return-Path: <io-uring+bounces-5185-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D65A59E1DB4
	for <lists+io-uring@lfdr.de>; Tue,  3 Dec 2024 14:37:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9C7AE165A1D
	for <lists+io-uring@lfdr.de>; Tue,  3 Dec 2024 13:37:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAAE91E570E;
	Tue,  3 Dec 2024 13:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CR5Ki5Gg"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4849A192D98;
	Tue,  3 Dec 2024 13:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733233038; cv=none; b=BFFzIaSUFwrYR8xeiAvUb3HABuCgUtZ1Zl4kKKeNSxg7IEePdm0QedlQUa1iJBM8kzHdQFNZDeKPF1fDmwDbq8ujytuHQYLOrnTGjUvF1f2FttLzYEhL0T9e0Edi06KjfBUajC1rNRXPszKquulsjpleJx06ibU9eIv/HQZIFrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733233038; c=relaxed/simple;
	bh=ma99hyrZiITfCBCvtbX3djutK4ofuTTwRjCoH+7CJQY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ArKLh2exEmhhwe2PvM8BeNGvzyAdSPHVa4mIPpZZJfb86I4t9xfYVOqDHDdWLwOpckrKsyV91wCIgn3X+T4mwwg20XrbSaoOwnVMyPlcoZPfQktwFXQ4SHzImxk/3ClCAF+vsIiKbDcFmbWBC0ToCFhzegKBKkaFL8aQY8ggXDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CR5Ki5Gg; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-a9a977d6cc7so330385366b.3;
        Tue, 03 Dec 2024 05:37:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733233035; x=1733837835; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jeL57cvkaPTgZDxyDQAE4fTxCdYBo9rZbJ3ATzfcHRc=;
        b=CR5Ki5GgIPQaYDFwpHqp9EHWvCnvMX2zJfaMoD4bGZYMgKvxinnJ1/29XABN1jJhg6
         Jiw8VgG5cXFYNClwqa6SCRcAAJNFPHBI7pddcFM5QR5Mx3+4MD+AtDL7aD3u58/D4Z3F
         dCCrhbVJ1203atAXp5CcwQ1Rk/jDlK2abGYgMoAsmj9DTvPIAlqbWO2KJXP86VSdy9SG
         4KcwnJrEjSt0BHM5Jft4JemxNTeyufstmpP8E1Tad7bKO5kKCNAjMII9ZIFgFXjvjXrI
         ZesEp3Nl2ejGyyIehL5nUD3fvTbwkvY1EfqTkg9ph55uvH7Pa9gvL53Unj3+x8jiWbBI
         pukw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733233035; x=1733837835;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jeL57cvkaPTgZDxyDQAE4fTxCdYBo9rZbJ3ATzfcHRc=;
        b=a4oozj66ITyMWBgS7MtbPudxKICv6iS3wNKwDa1FWyCKmDDzrvfNCFDowXtBNzgRBE
         5xkCcBz3EXYdU+UeGN9msGpHyzhKpyp6w4EFVwXFx2UVjG8G9+OCf2kYnVW61kAleTP2
         C3am4B0Pu/jhFwK/UmaFlKS5FfaZoO/yLt8CdkkktQYBtwFJC43NG3pvMy5hGFZj5OEu
         JMhQaoyQ3OdJHtXcI2pBaXY61tFzF6hJUJOSdXkpzSGsVGaUQP0ohuAOcZ4Net6vxnR9
         leNLcce3mQYxQdthTMxSfDpa7SUkZBVoYwUyHheqWlZXJolDwkriGJeTqxfbvp8qxyoY
         J7hg==
X-Forwarded-Encrypted: i=1; AJvYcCULvBqxBHG3bpqpGcKL8zWDpQYBFGdOe107cYKRLxnKJ99+HtnoTPc0DB6MMGJVRCFMrum7tLNF0g==@vger.kernel.org, AJvYcCX1xqVPWX+sHDHSGlwSDWd4AY7cstqRX7kJsdOexHGjJvukan0dOxbVtKNjPMysPRxsojhKkqt6jtNmhxqMFg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzOdIhg+CXFBNEpOj5IUtJ+QmmufQPzKAr9z9/LrXcWtcZb6K2n
	dt+OWtM1sOhIPDQmEiLprgj0zhXBMQeHts/4cxhKGLVo4gAT/9r2G/uyxw==
X-Gm-Gg: ASbGncvLjd23oZYCcLVwJCbJWXUfrbGslBOcBPmz0tifYs5NvV8I1Vd7kY5Y3J+qS4W
	UWpWs+m8q5dZcG4m1XzhE9xbsZK9mHu/GFKz8Rz843aZ37v+tVNjrkq+kFhb1ZDNin8Enj3wtvF
	+ZmIzxm5Y1Z/tAtphmPNyRd5VRDcPdfyvskIa6YRANyEUKMT871mmqdU/eFF9gNyTRYaq4dJpvD
	egHDmRxt0+WzONL8lWyqSqRdG0j1VNkAwOOZsCLTBxy/XmcFq1ONLdZpP7uVQ==
X-Google-Smtp-Source: AGHT+IG/BbpX5CHVXnI1sHJE+eWGAu+2AfgziP/YR4PmGqAzQuif7TiLYbLlZRrcgaeTm9t1vhG1EA==
X-Received: by 2002:a05:6402:2554:b0:5d0:abb8:7a3 with SMTP id 4fb4d7f45d1cf-5d10cb4e69amr2212563a12.6.1733233035379;
        Tue, 03 Dec 2024 05:37:15 -0800 (PST)
Received: from [192.168.42.149] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5d0b264f0d2sm5044174a12.72.2024.12.03.05.37.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Dec 2024 05:37:15 -0800 (PST)
Message-ID: <efb34163-9498-4020-bbf3-d669932b24a6@gmail.com>
Date: Tue, 3 Dec 2024 13:38:11 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v7 06/16] fuse: {uring} Handle SQEs - register
 commands
To: Bernd Schubert <bschubert@ddn.com>, Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
 io-uring@vger.kernel.org, Joanne Koong <joannelkoong@gmail.com>,
 Josef Bacik <josef@toxicpanda.com>, Amir Goldstein <amir73il@gmail.com>,
 Ming Lei <tom.leiming@gmail.com>, David Wei <dw@davidwei.uk>,
 bernd@bsbernd.com
References: <20241127-fuse-uring-for-6-10-rfc4-v7-0-934b3a69baca@ddn.com>
 <20241127-fuse-uring-for-6-10-rfc4-v7-6-934b3a69baca@ddn.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20241127-fuse-uring-for-6-10-rfc4-v7-6-934b3a69baca@ddn.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/27/24 13:40, Bernd Schubert wrote:
...
> +static int fuse_uring_fetch(struct io_uring_cmd *cmd, unsigned int issue_flags,
> +			    struct fuse_conn *fc)
> +{
> +	const struct fuse_uring_cmd_req *cmd_req = io_uring_sqe_cmd(cmd->sqe);
> +	struct fuse_ring *ring = fc->ring;
> +	struct fuse_ring_queue *queue;
> +	struct fuse_ring_ent *ring_ent;
> +	int err;
> +	struct iovec iov[FUSE_URING_IOV_SEGS];
> +
> +	err = fuse_uring_get_iovec_from_sqe(cmd->sqe, iov);
> +	if (err) {
> +		pr_info_ratelimited("Failed to get iovec from sqe, err=%d\n",
> +				    err);
> +		return err;
> +	}
> +
> +	err = -ENOMEM;
> +	if (!ring) {
> +		ring = fuse_uring_create(fc);
> +		if (!ring)
> +			return err;
> +	}
> +
> +	queue = ring->queues[cmd_req->qid];

cmd_req points into an SQE, which can be modified by user at any moment.
All reads should be READ_ONCE(). And unless you can tolerate getting
different values you must avoid reading it twice. It shouldn't
normally happen unless the user is buggy / malicious.

> +	if (!queue) {
> +		queue = fuse_uring_create_queue(ring, cmd_req->qid);
> +		if (!queue)
> +			return err;
> +	}
> +
> +	/*
> +	 * The created queue above does not need to be destructed in
> +	 * case of entry errors below, will be done at ring destruction time.
> +	 */
> +
-- 
Pavel Begunkov


