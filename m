Return-Path: <io-uring+bounces-7959-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B799CAB4EE2
	for <lists+io-uring@lfdr.de>; Tue, 13 May 2025 11:12:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9930D3BADE5
	for <lists+io-uring@lfdr.de>; Tue, 13 May 2025 09:12:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2014C213E9C;
	Tue, 13 May 2025 09:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CACUYGAj"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84FDA212B2B
	for <io-uring@vger.kernel.org>; Tue, 13 May 2025 09:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747127534; cv=none; b=b9AirdmSSYrSnvBXNwZS0b8Y38kLWO2Jol6zChcX1+rS5S4xm+8RVcri043FbxAHQ01Ad07exRWlzJAVJ3cm6n6bW59o08eC4Q1rMngv8Kqlcg6SCRlHVKrdiFMvG8cBYOFn6ll+NewYIBcfa0meWAGyY+DFfg7/Cco3wK2/KXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747127534; c=relaxed/simple;
	bh=WDlpFsWbDcfzZLGnp/d3QNExJHb0unwOgNVXbvwod6g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ptJHkUlBt6A4nPb8lXHwCx/orH0eQu2WRlsgqQS8R5KT7e6XBsCSzZL1s8LSp23T1iyMTlLNk1hOb/45Np4iL+XFsP4JM/EXhDNrANSPcZTd4uU+AbWwiAspNbFiEqDYgaGXb4cC0wVNVHwEgi2l33Z2hkQ897005uOSXyj0+GY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CACUYGAj; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747127531;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lSKXGvXgaIuXifWFUaLvMDff9Ik6twAKIvR+Y496sQE=;
	b=CACUYGAjsm56aOJwv6UP3RGQM2dzjQ896IV1q1FoIdH1qXZEiZiFqZgbtWDAzIbsNo6lGp
	TajrgtCE+ZyKdzUmVwWMVA4JzWokwTFOKNf4R/IAA5wd9FHrRG6LmmDkz/B3hsWJafUY6a
	hYAGkAN7e7HLHb1rS8bQfpftAUK7yoc=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-691-yq-H_KQ5MBeguC34_RIEIw-1; Tue, 13 May 2025 05:12:10 -0400
X-MC-Unique: yq-H_KQ5MBeguC34_RIEIw-1
X-Mimecast-MFC-AGG-ID: yq-H_KQ5MBeguC34_RIEIw_1747127528
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-442cdf07ad9so22222805e9.2
        for <io-uring@vger.kernel.org>; Tue, 13 May 2025 02:12:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747127528; x=1747732328;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lSKXGvXgaIuXifWFUaLvMDff9Ik6twAKIvR+Y496sQE=;
        b=roCJq62jO02ruKlnlegS1NyF0e0WxnJzKwRJ6IRzBNrIfXOerR8c7Q3bmciz2c+eQz
         H8ltpSBabavueCTjwNcmU4XaVymlXUEay5zxzevu5Ywg5mA0VuM2sKkyqoo9QtW6kjv/
         LEj9eaBKaaGFYP4neBpRCjicJ2WaAGSN1Z+0upcB/857ze85wJOIpIPnkAmiSMj+Z6tU
         7PMxnYO7KeLlVihELxtvqRMGa0hukCuJByFsCqJTH/gSBVve/lRyQpA1tBMPpVscqokn
         gC9BZ0Myl9jWYcGDEJ/v/jsvosZCVyitus1ibSOEZjbkeEik4Qd8StiY5Sa9QM0mOjhg
         RQ1Q==
X-Forwarded-Encrypted: i=1; AJvYcCXmiyCkqFQ51+jdniigid9VDqUdYOiBWyWhM96eHTUOfsakoRs2dimqGAMJqU5PK5Zh+d2godRApg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwI9ZZBwgwLRttWw5/WKEyHDExdNpwbaM0u6KeHyYveQeTzKSQU
	PfqammHGINgdbRdBOifrVTzGNkMcHB1vQd+VmdwN48P9TMamOwvZTBwg3A7OOMGj0cP1oLMMHZM
	SqhyBA0fIGlbFlQ/4gc9BZ4vsI4h389KAGrORObdJvevMZ8ESiIYhXeRR
X-Gm-Gg: ASbGncvYR4aQ4ZaeZuIllboc72qUiXMBo7RT1jgBvUvFnc4r41puHRtdnq5Y7M/h0vn
	rHjdzMoA04F5YvQ2zpmpltdL3BI0tDWlIwDBx/XjosK8eLa3nrglZGsuWnY/rK1uF/2qWqC1JJM
	ARgo8Ke6ZCWJpFiLqrHArFyxLjI1cWY/mDOyRnfsYV5rmui6ePbx0smUTTriDjvujM6wzPISir6
	tlpZ5Q+W0jIx9tk8ZDwHEhYag+O2Orpm84AkLuwC1OxGG9/4hQ3DoPFI9a+Njd4+TcijZWABSMm
	2pd3cEWWvrL/hRz9eXI=
X-Received: by 2002:a05:600c:4454:b0:440:9b1a:cd78 with SMTP id 5b1f17b1804b1-442d6d44aa7mr175600145e9.10.1747127527697;
        Tue, 13 May 2025 02:12:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF7UByCIdv1fV6GeTCbxFUgA3MTskc+HSiE9ez+aliKyTiJ4Fv/7gBQk/cE3vpwwsDlBoiWaw==
X-Received: by 2002:a05:600c:4454:b0:440:9b1a:cd78 with SMTP id 5b1f17b1804b1-442d6d44aa7mr175599485e9.10.1747127527311;
        Tue, 13 May 2025 02:12:07 -0700 (PDT)
Received: from ?IPV6:2a0d:3341:cc59:6510::f39? ([2a0d:3341:cc59:6510::f39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-442ea367102sm36670345e9.3.2025.05.13.02.12.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 May 2025 02:12:06 -0700 (PDT)
Message-ID: <085a78fc-acfc-4a86-9dbf-18795ad68b4c@redhat.com>
Date: Tue, 13 May 2025 11:12:04 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v14 4/9] net: devmem: Implement TX path
To: Mina Almasry <almasrymina@google.com>, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 io-uring@vger.kernel.org, virtualization@lists.linux.dev,
 kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc: Donald Hunter <donald.hunter@gmail.com>, Jakub Kicinski
 <kuba@kernel.org>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Simon Horman <horms@kernel.org>,
 Jonathan Corbet <corbet@lwn.net>, Andrew Lunn <andrew+netdev@lunn.ch>,
 Jeroen de Borst <jeroendb@google.com>,
 Harshitha Ramamurthy <hramamurthy@google.com>,
 Kuniyuki Iwashima <kuniyu@amazon.com>, Willem de Bruijn
 <willemb@google.com>, Jens Axboe <axboe@kernel.dk>,
 Pavel Begunkov <asml.silence@gmail.com>, David Ahern <dsahern@kernel.org>,
 Neal Cardwell <ncardwell@google.com>, "Michael S. Tsirkin" <mst@redhat.com>,
 Jason Wang <jasowang@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
 =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>,
 Stefan Hajnoczi <stefanha@redhat.com>,
 Stefano Garzarella <sgarzare@redhat.com>, Shuah Khan <shuah@kernel.org>,
 sdf@fomichev.me, dw@davidwei.uk, Jamal Hadi Salim <jhs@mojatatu.com>,
 Victor Nogueira <victor@mojatatu.com>, Pedro Tammela
 <pctammela@mojatatu.com>, Samiullah Khawaja <skhawaja@google.com>,
 Kaiyuan Zhang <kaiyuanz@google.com>
References: <20250508004830.4100853-1-almasrymina@google.com>
 <20250508004830.4100853-5-almasrymina@google.com>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <20250508004830.4100853-5-almasrymina@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/8/25 2:48 AM, Mina Almasry wrote:
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index 86c427f166367..0ae265d39184e 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -1059,6 +1059,7 @@ int tcp_sendmsg_fastopen(struct sock *sk, struct msghdr *msg, int *copied,
>  
>  int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
>  {
> +	struct net_devmem_dmabuf_binding *binding = NULL;
>  	struct tcp_sock *tp = tcp_sk(sk);
>  	struct ubuf_info *uarg = NULL;
>  	struct sk_buff *skb;
> @@ -1066,11 +1067,23 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
>  	int flags, err, copied = 0;
>  	int mss_now = 0, size_goal, copied_syn = 0;
>  	int process_backlog = 0;
> +	bool sockc_valid = true;
>  	int zc = 0;
>  	long timeo;
>  
>  	flags = msg->msg_flags;
>  
> +	sockc = (struct sockcm_cookie){ .tsflags = READ_ONCE(sk->sk_tsflags) };
> +	if (msg->msg_controllen) {
> +		err = sock_cmsg_send(sk, msg, &sockc);
> +		if (unlikely(err))
> +			/* Don't return error until MSG_FASTOPEN has been
> +			 * processed; that may succeed even if the cmsg is
> +			 * invalid.
> +			 */
> +			sockc_valid = false;

It occurred to me a bit too late that this chunk of code could be
cleaned-up a bit using a 'sockc_err' variable to store the
sock_cmsg_send() return code instead of the 'sockc_valid' bool. It
should avoid a conditional here and in the later error check.

(just to mention a possible follow-up! no need to repost!)

Thanks,

Paolo


