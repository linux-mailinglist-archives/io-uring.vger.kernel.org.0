Return-Path: <io-uring+bounces-10719-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id DB05BC7921D
	for <lists+io-uring@lfdr.de>; Fri, 21 Nov 2025 14:08:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id B1E814EC5BC
	for <lists+io-uring@lfdr.de>; Fri, 21 Nov 2025 13:04:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 478E61E0DE8;
	Fri, 21 Nov 2025 13:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kJHXef3K"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9304E3396E5
	for <io-uring@vger.kernel.org>; Fri, 21 Nov 2025 13:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763730265; cv=none; b=eEB/ZivMbobzbEhDKHNiUiI+i/SG5PZGnb8XIsT9JOxhrRWnFJWmfNEF+AxnqJg5p/QQ3muTlM24al2tAVqoM43VPQ9Vsh9of2lWKzJpya2Zjl4+RdA9LbAPAW2bOE1Jdzr+kWB8d9+huACZ9+Nu7rRdEz7vjlNJcGwTp7ruVkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763730265; c=relaxed/simple;
	bh=WmDpJwTQ154ISU0m7eNtakVDDgm05vUmUtyAf1ww5Uc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ecx//HJXmyqBTl6AyC/O/FK0s7NRNFXhvmnhrPcCINebBGFwKBcFw7Xe6l78JLetsOT3O2aEN6QRUx+XLqZb0X/zMG0OzXiOYybiRdC+Rv5ObYVcM9xsQPoO0uMfAt3Chqb3xwh52JlY2oq6UpTZumnLb++tysbncNz5Dw+JnTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kJHXef3K; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-429c82bf86bso1239335f8f.1
        for <io-uring@vger.kernel.org>; Fri, 21 Nov 2025 05:04:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763730260; x=1764335060; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+hGhb6xgX2y8Cv4H8jg13ylU4BfkqOlg8uqpNi0jito=;
        b=kJHXef3Kea1hoEyrcYD/HJArOfyPoHdQQmI49l14kfQPL+YMaARkjVZ6jziO8VU+ww
         XY+019I6NQTrKkm67mbBA2bXNVrYj+RJ1aAOld6XjfjS8A80u2uctlWq1jE58hwvDijq
         H/FjAudm4onD26DT7F4GVGKeZUfZMNP5UPdNLhrP4jCioRMWtGLZWdKaS/lShlQDU6lI
         y4JtjUWGzVAAKW8SyqxuxHsseKFU+CLZbfZ0kS2iXLg3ZTMqe0Wzm2JZCStQBfjyrMZo
         vzY42McUu6qfUXEi8MoB1NfJFNcxSzGZxfxJOknjGODp4pOm7yWMDf9s1hhoyojQMWHu
         StUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763730260; x=1764335060;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+hGhb6xgX2y8Cv4H8jg13ylU4BfkqOlg8uqpNi0jito=;
        b=MYwsM4IXZuWTncWlXzKkY0ohYW3HnDEagXdUQEX7l+ByuSaGvQnbV1N3Q39Ahy1b0K
         2P6CMl9NjBlpgfYr+xWsfzqrUDYXbgBT5AH9muaBYs04WS1uJ4MRig1JblPZdM98WqYO
         R+vhIj3/ys3rGgAjtwATMuRh1N7YxNjZkocECeCcf8z9UY4agaKhWkFI3qq36HiqnCQ6
         J7GtR/urIvoIgrVMQviSLXpc2XCo9bciJw5QXK9a4fcQ1+bEMJ5faG0ONKdZr2LXkSwW
         f0xcPk+Y92VIAOFWOuVh19Uftg7yA3lp7PMLGlZPr8phzUb0lld5FlhY6HA+R4wvUL07
         i0qQ==
X-Forwarded-Encrypted: i=1; AJvYcCWpMGlq5QUft/thj0I/5bDFBy43yV06ZWjbI7sXT+3fenV0yNSsOENpSzEa0NBdyM96s1wFJBNaPA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy4jr6wqm/ZGKGH4H/72CJgRvYC2BPS+sjxI4THRtr9jalxkfbM
	vrQ9iddZhSXQSQyfAxtViOJhSNtDxuHUoLdmjeYVF5qp6Swq9i3q1lFb
X-Gm-Gg: ASbGncuPGbn+uwgJy9uL4dhHlO4U0bugb8R3pnG4oV4rvjsoFsOnknCi4ZBPGH/eDvu
	e+hdNjZERGNf6AYXM4CDYQpbl4ttdTpLrogFwoD0DKuu9Sazj4BgA0+Ty65g+5+KiVrQjnwJlF6
	A/Ol3OpSe934WDItyEedhSaiiCod3U9ZH7ig3V0hk7M5XI0s/IPJS5s55/J4SgQwffpA2cFM2ju
	eoGUMWlMgrY0DEYeBU+TkbLUXgU9+DhA3S9eDIih2+YRzXr3+b9O/OAsntDXvs7yIgNWG3L3pRs
	wdOmfC7fWrfOPUcWOfK0g7h27OGHoXUV9wlt5VdFZCXSBFzkRG/s5Vjw4tvk1xggMUyU1fEfyB6
	6GY/6LkF7szaqHG/eaP5341biQzzReQWB0vYHWfIsZjko1UUnoILephlkB6tmKyZ8zXUQ/9OMgK
	yAUior2NAOT94yn7X1KUTJbFtW5bGoGwl9ZKKICVpt0jA=
X-Google-Smtp-Source: AGHT+IEUyfkkATekh7ulM7LuJzIlOC1XYWL+JvSgyjtOyj7Vn540ELYt7m8DbsLt3VH5KIz9Q8D7Qg==
X-Received: by 2002:a5d:64c7:0:b0:42b:4061:2416 with SMTP id ffacd0b85a97d-42cc1d19643mr2343892f8f.52.1763730259856;
        Fri, 21 Nov 2025 05:04:19 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:813d])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42cb7f2e598sm10743641f8f.4.2025.11.21.05.04.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Nov 2025 05:04:19 -0800 (PST)
Message-ID: <1f13f400-206e-4ea4-9225-079672626024@gmail.com>
Date: Fri, 21 Nov 2025 13:04:17 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next 3/3] netmem: remove the pp fields from net_iov
To: Byungchul Park <byungchul@sk.com>, netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 kernel_team@skhynix.com, harry.yoo@oracle.com, hawk@kernel.org,
 andrew+netdev@lunn.ch, david@redhat.com, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, ziy@nvidia.com,
 willy@infradead.org, toke@redhat.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 axboe@kernel.dk, ncardwell@google.com, kuniyu@google.com,
 dsahern@kernel.org, almasrymina@google.com, sdf@fomichev.me, dw@davidwei.uk,
 ap420073@gmail.com, dtatulea@nvidia.com, shivajikant@google.com,
 io-uring@vger.kernel.org
References: <20251121040047.71921-1-byungchul@sk.com>
 <20251121040047.71921-3-byungchul@sk.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20251121040047.71921-3-byungchul@sk.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/21/25 04:00, Byungchul Park wrote:
> Now that the pp fields in net_iov have no users, remove them from
> net_iov and clean up.
> 
> Signed-off-by: Byungchul Park <byungchul@sk.com>
> ---
>   include/net/netmem.h | 38 +-------------------------------------
>   1 file changed, 1 insertion(+), 37 deletions(-)

Nice!

-- 
Pavel Begunkov


