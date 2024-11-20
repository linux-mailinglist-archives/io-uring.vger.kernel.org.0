Return-Path: <io-uring+bounces-4904-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 474B19D44A2
	for <lists+io-uring@lfdr.de>; Thu, 21 Nov 2024 00:44:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0C06D283213
	for <lists+io-uring@lfdr.de>; Wed, 20 Nov 2024 23:44:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E220C1BD9F3;
	Wed, 20 Nov 2024 23:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bcHvcpeJ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3EE41BDA84
	for <io-uring@vger.kernel.org>; Wed, 20 Nov 2024 23:44:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732146269; cv=none; b=bIQCkfysano2hYEVlkYHWQ0E6pOVrIEoouKhleMAvjGbk7Z4Krec9qQbvlvWBZmz1S5YBq8DjxEGLCg/maS+0WloDJByvsq/yPEsZQvCXcIJCntIcfOZfDWHuRVUnaJeR1E+/vgeHTaKIHEKP39nfHK1oFIZd0cqX3FKtFyq4bA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732146269; c=relaxed/simple;
	bh=+wuLLvcr5PQUrYRRaxfjCgQ/fn1dkFffF98ulOutC7o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WTpMT9XUG84paShJAM4gxHaqP9ZwrHUfVF+64m9FWkJx0RjRaUnSmiYKh3bJqYu8+YJ2tbtW4jfg+ukID5i6O5d7x0E/0IhkNPVMyNkVGIYmKdS0vqy9zRzIAZsvte9PXFWuxBEW2ezqH6VTZhfrHpUjDYfSJ56ruA2mtPrOur0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bcHvcpeJ; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-a9e8522c10bso46256166b.1
        for <io-uring@vger.kernel.org>; Wed, 20 Nov 2024 15:44:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732146265; x=1732751065; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6n3Zlb6mp98HHEsYJzKc2PcQM+UFsFj3tcp/ojV6VqU=;
        b=bcHvcpeJ4F44iOaMnxD+8ss0t62PRD6jIqCm4TawFDa7qMUgE/kD5fVnkJnQ3qBzi5
         44Hlbk9wql/JdBQy+Wir6ruj3wWx+GnJUCTopJk6oT9QmfBFu1ckUtjoyhb0t8fLFeaO
         b7O+MLMoQHtqAQnjzqfO+KdpsahxlfoXs65ysVdw3HZKKZXSyUFkZcQsVrjGhfBysMEw
         R2wzSEliqXNSC+KAWrdaDKOIDM6oh7QW4lR7l7I4qoWd37fM5Q+i6NbNXaUxUKXhU1nY
         6gQBA3EPkz8yQWa/HK+EoUcT16vDQF0n+/IFaOYWckN4T9nmgif9epoQRRGNAFn32GSY
         I4Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732146265; x=1732751065;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6n3Zlb6mp98HHEsYJzKc2PcQM+UFsFj3tcp/ojV6VqU=;
        b=EJbzWDwE0/rXrda+GPfXsS4WTwsibkFL84HMTT6IuYh+cckdFx2huvEZuNNdbIlckW
         NV7A8svi1FiQkBglOL6FNc11BVoNhQo5GLOxS69ljOpPGbqDsCDibG2qDVIokfTjEC1G
         vCYjXBnhs1JWOuxHH4RhMB04zKWIdRISSHrpIy/mF/pMWm2jWoLDMBDRn1I26XUyXn6D
         32yTjRecJ8wH8ICAg8eJaXtO5C6QREmE71XtlhbrFwJOmOtu33ChR1KsNMtdMUc5axZG
         6jsBUL4UUb8XymBL7WCa7aR6U4stAg8taEizloL/9bRYisLZiyweNJhgg60JHvv0U+7W
         lENQ==
X-Forwarded-Encrypted: i=1; AJvYcCWoU6ILZdaOt0/vcceAkiLYoTSAm9p7htcDGHc1szwtVpuWcC9Cvl6oSwPoav943kHNIAObno5ZBg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzdGl02Xfj1rUdui9J03hLskU2aJ50F+1T66fbayYZnsS+ubjhv
	XEa2LIcWnIy3Mb5gDsm28du7s0x0ACAuJRGrPMFtUThpitSuQEotqG8kAw==
X-Google-Smtp-Source: AGHT+IFXx12xezc2GnUJiZjAwXzZOzP0ZGiWOxa33zjf4Hxguo8VXBbME74xqcmWlQFXxSRZ2apFgQ==
X-Received: by 2002:a17:907:7b86:b0:a99:f5d8:726 with SMTP id a640c23a62f3a-aa4efdd0c3bmr87974166b.23.1732146265222;
        Wed, 20 Nov 2024 15:44:25 -0800 (PST)
Received: from [192.168.42.89] ([148.252.141.165])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa4f431a7absm12229466b.143.2024.11.20.15.44.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Nov 2024 15:44:24 -0800 (PST)
Message-ID: <3f0f048b-c766-464c-8d46-2ab9e65319b2@gmail.com>
Date: Wed, 20 Nov 2024 23:45:18 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH next v1 1/2] io_uring: add io_local_work_pending()
To: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
References: <20241120221452.3762588-1-dw@davidwei.uk>
 <20241120221452.3762588-2-dw@davidwei.uk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20241120221452.3762588-2-dw@davidwei.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/20/24 22:14, David Wei wrote:
> In preparation for adding a new llist of tw to retry due to hitting the
> tw limit, add a helper io_local_work_pending(). This function returns
> true if there is any local tw pending. For now it only checks
> ctx->work_llist.

Looks clean, we can even take it separately from 2/2

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>

-- 
Pavel Begunkov

