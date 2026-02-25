Return-Path: <io-uring+bounces-12422-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +MN4B4g4n2nyZQQAu9opvQ
	(envelope-from <io-uring+bounces-12422-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 25 Feb 2026 18:59:36 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A65BC19BED7
	for <lists+io-uring@lfdr.de>; Wed, 25 Feb 2026 18:59:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2D5123058579
	for <lists+io-uring@lfdr.de>; Wed, 25 Feb 2026 17:57:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86EFA3ECBF7;
	Wed, 25 Feb 2026 17:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FmNrBKbX"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-dl1-f53.google.com (mail-dl1-f53.google.com [74.125.82.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 403673E9590
	for <io-uring@vger.kernel.org>; Wed, 25 Feb 2026 17:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772042252; cv=pass; b=uEUqFwvrH24LekvUHnyYYCOXluf+mAdXLfX4oP9AInWIlk+DRxuWQD43FSRwYj9DQx/dTVuGhrKOmNMSPSBg0zd6xl/v2yqShLYPaJ0kdMbgVF1jyJuCjbFZdxuel++HHs2wgufHFk4gYj5OsqT0bifVxYUttqrPcz5dYD2lJDI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772042252; c=relaxed/simple;
	bh=RfpExGJammZbpKVHCDHyUsPNDozKMq43E5upG27Qk/M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=f/XBb/7dkrFhjBmZa2Kv+KzNBdZXCucFPAKpQZV6Hv5VjNXQjSMnRc99lOi5TuhQf8cs1dmNF4i+IllQKrZLxSrcHKX4hSG+5GnnhNQK48mpzP4CO5R+V5q+NeNA6IbWJnEwAm9IBmJMUGMpEJvEyCd11PnJT9ITSy34cvn2XZ0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FmNrBKbX; arc=pass smtp.client-ip=74.125.82.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-dl1-f53.google.com with SMTP id a92af1059eb24-1270f10a774so250c88.1
        for <io-uring@vger.kernel.org>; Wed, 25 Feb 2026 09:57:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772042250; cv=none;
        d=google.com; s=arc-20240605;
        b=cYIfLAR7h8/mbXHOzdBGzBKxgnt2cnAEgfYz4EuqK0lsRJoaYGLKYP76DlMYM0ZYtJ
         GYlye9PinHJDp/sfLc3uix2DXOi12h1421zZBAGcSacJag1aOhhlhku0EKcBXl7nC0Qy
         yF1d+gzgAhDWkU76QlUTet+N1+LRPjjLrEP3nau3QiT56H66chZSQzGWP1p8EiSH2x/V
         5Kv2bKClp8GKWiZpgqIQBt2sHn7IwHh9GRDvzwXKsF4YkE37t183BMKbJYy0PIChed8Q
         F8K6J82EeJI5tzrkfsILxVYfG0GiZH8w0V48IQ6ultMmh0kEiS/wGbcX/rzgnA/jL/II
         RSNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Om7WA+0rDJMCyh+EuthvxH1P/DwUlMRij1gLg5qOqPQ=;
        fh=FUU9UaXXPSDSrodubsBcpJv1mpIJ68VhkWgwuDLWEu4=;
        b=TIqe8tf+EMltgSbyThrAIvsJYd5uAe5YV66v9MU6PjjJod3P3Uhc+Tq8uc45omCtoI
         l5vNER6w6QprSdnNNi8VJH81wFDTs6C/MQcAlIzWvRMj0Hj82PlBbCYXkUnQ7aykTE3h
         BhbzMUQhznxrmt7zkrvZ42lgO61n4b7Obl2udJJJARj7vSlTHTG89WK6T2D13BP6wWt0
         1ViCgS3YKrlcW4Gsce1WilbXomthzqz3SiHvyTyAkIkfAW0DcMyAsUmCpWdcfP7qzEB6
         eV8qHGIDRL7Irqx0d0hbl8XhJnt+ROykgpAIod3SIW2e/8y8dO78bYcXccZCSSARLKsJ
         uWFg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772042250; x=1772647050; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Om7WA+0rDJMCyh+EuthvxH1P/DwUlMRij1gLg5qOqPQ=;
        b=FmNrBKbXKgagz9dIZmKtrpC/1ec4UhjpsTh+62ISKnkacPtBlVUzdR8Yg5PRzIp9Mm
         5Rzviq99gQoW/OevItlRp82HLlHb94ci0wBYEGGeA/v3RSU9E6zBGvxUN+AT0Cv3IdjN
         ome3PS9mdqvgLQ8nTKHdkcpZWsxL8y0qTjo4DhA2a6BvTT2nFtaRotZufNQ0yw4FhvwP
         F8efDLl3ec7H+gzGI70ExQ/rC3s43EnBW/wPwGLNxBeUBEHpFOGsTPA6jxd9IrRFK8dj
         s3yXm+lovd8t2D/rk6KPD654FoplSjjEBzJ025bKVgtSMT0bEa1YETBSZF1gmXPUBIBS
         ECaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772042250; x=1772647050;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Om7WA+0rDJMCyh+EuthvxH1P/DwUlMRij1gLg5qOqPQ=;
        b=ETasV1h4/cmnZQ0bFHlYaMi+Qh5W3fh2Xx5GcxhRqHSGvn/bi0Wbz3aZO6vqHv0UuC
         040n1LkM/GbRFTT9dXToy5mTNl5vtyysJ/bfLDi+UE6QIAi4mTehS5fkv5AiDfJYp5jH
         /2d4TdbVXipQCu5MHSed/exhReq7UPof0LA7e8S4FN7d9c1iF0r20toPdNSX7e3EFkK6
         b2Gl75o77xD2I8CotBruC+VyOVi3O8K7qzKBDIa6vmpXq9SOj+9D/VE6Ood35JjhJnjD
         95gp63O1qJiqeBKZwNS2rbBo1myotSrtyyCqJ2XQo92RSUFNAUzDzo209Z2C03LdFzW6
         cnDQ==
X-Forwarded-Encrypted: i=1; AJvYcCXWmiwklSwyI+uO+lnFAP4EsvLwr8Es71V49p46A7wWKXYPLRpanb4Ub4ohfgxvKrrVqxheUbdHVA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzFHS8ZEny+4Z0g+gVIDvO85zxCeeaEBhyKBlb9F7jQ+JIV7Zf9
	SWH0vrOkZn3OJcpqd+kdvMaAeFrHr+T7JyOQvcasCBIcLPRriRMvKLFozNgj9aROveCrJhW8UC7
	ErftVFve8ykGxwffbySPzzJKsQgrFjSJWp3MIEVzm
X-Gm-Gg: ATEYQzxx9Tj+CLY+liQDST9ze6a5yb1/S6eWCHKY1ZNkZRDyCf9ly+NHBTzVGROAqzb
	335fzuDCmroXVJFu6udFjic7vLjKG3NK9UoIUKSSFhYHWu1Aencr9fgEMT29wwxf8LY993KmMq4
	wZHG8GlR7c7fYmYcq3A6x3EZqlgOomtrt87N9qWUzpCilOsNOnQ9GayJHgv7LZoW/COnxNzGUqI
	XLunGgetcfkC2FbVzjtKsqBt+dT+JzCO/3LylzZ042LAEzcf3HvFrvkdS6aerPd5BkQ8bidxOyn
	qS7XCqoSRJFxUeCsB7s8RCgpU4wwbbuH3pFY9HmN
X-Received: by 2002:a05:7022:229:b0:119:e56b:c1de with SMTP id
 a92af1059eb24-12781cfd467mr170045c88.9.1772042249674; Wed, 25 Feb 2026
 09:57:29 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260224061424.11219-1-byungchul@sk.com>
In-Reply-To: <20260224061424.11219-1-byungchul@sk.com>
From: Mina Almasry <almasrymina@google.com>
Date: Wed, 25 Feb 2026 09:57:17 -0800
X-Gm-Features: AaiRm52vhIdwB8NdZd7JgaIXodcRDphEOHqkxN7idSkBUfk5IzYKeF_O7pMnx5E
Message-ID: <CAHS8izPjfrKFNtvkyODY7HXSsAuQuPhzy3+fMyYTFuWKQJZ0Fg@mail.gmail.com>
Subject: Re: [RESEND PATCH net-next] netmem: remove the pp fields from net_iov
To: Byungchul Park <byungchul@sk.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	kernel_team@skhynix.com, harry.yoo@oracle.com, hawk@kernel.org, 
	andrew+netdev@lunn.ch, david@kernel.org, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, ziy@nvidia.com, willy@infradead.org, 
	toke@redhat.com, davem@davemloft.net, edumazet@google.com, kuba@kernel.org, 
	pabeni@redhat.com, horms@kernel.org, asml.silence@gmail.com, axboe@kernel.dk, 
	ncardwell@google.com, kuniyu@google.com, dsahern@kernel.org, sdf@fomichev.me, 
	dw@davidwei.uk, ap420073@gmail.com, dtatulea@nvidia.com, 
	shivajikant@google.com, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12422-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[31];
	FREEMAIL_CC(0.00)[vger.kernel.org,kvack.org,skhynix.com,oracle.com,kernel.org,lunn.ch,suse.cz,nvidia.com,infradead.org,redhat.com,davemloft.net,google.com,gmail.com,kernel.dk,fomichev.me,davidwei.uk];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[almasrymina@google.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-0.994];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[io-uring,netdev];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: A65BC19BED7
X-Rspamd-Action: no action

On Mon, Feb 23, 2026 at 10:14=E2=80=AFPM Byungchul Park <byungchul@sk.com> =
wrote:
>
> Now that the pp fields in net_iov have no users, remove them from
> net_iov and clean up.
>
> Signed-off-by: Byungchul Park <byungchul@sk.com>
> ---
> The original post was:
>
>   https://lore.kernel.org/all/20251121040047.71921-1-byungchul@sk.com/
>
> 1/3 was covered by Pavel's patch:
>
>   commit f0243d2b86b97 ("io_uring/zcrx: convert to use netmem_desc").
>
> 2/3 was taken by Jakub and merged:
>
>   commit df59bb5b9af3f ("netmem, devmem, tcp: access pp fields through
>   @desc in net_iov")
>
> Now that io-uring and net core changes converge in one tree, I'm
> resending the 3/3, which is what Jakub asked:
>
>   https://lore.kernel.org/all/20251124184729.7e365941@kernel.org/
> ---
>  include/net/netmem.h | 38 +-------------------------------------
>  1 file changed, 1 insertion(+), 37 deletions(-)
>
> diff --git a/include/net/netmem.h b/include/net/netmem.h
> index a96b3e5e5574..a6d65ced5231 100644
> --- a/include/net/netmem.h
> +++ b/include/net/netmem.h
> @@ -93,23 +93,7 @@ enum net_iov_type {
>   *             supported.
>   */
>  struct net_iov {
> -       union {
> -               struct netmem_desc desc;
> -
> -               /* XXX: The following part should be removed once all
> -                * the references to them are converted so as to be
> -                * accessed via netmem_desc e.g. niov->desc.pp instead
> -                * of niov->pp.
> -                */
> -               struct {
> -                       unsigned long _flags;
> -                       unsigned long pp_magic;
> -                       struct page_pool *pp;
> -                       unsigned long _pp_mapping_pad;
> -                       unsigned long dma_addr;
> -                       atomic_long_t pp_ref_count;
> -               };
> -       };
> +       struct netmem_desc desc;
>         struct net_iov_area *owner;
>         enum net_iov_type type;
>  };
> @@ -123,26 +107,6 @@ struct net_iov_area {
>         unsigned long base_virtual;
>  };
>
> -/* net_iov is union'ed with struct netmem_desc mirroring struct page, so
> - * the page_pool can access these fields without worrying whether the
> - * underlying fields are accessed via netmem_desc or directly via
> - * net_iov, until all the references to them are converted so as to be
> - * accessed via netmem_desc e.g. niov->desc.pp instead of niov->pp.
> - *
> - * The non-net stack fields of struct page are private to the mm stack
> - * and must never be mirrored to net_iov.
> - */
> -#define NET_IOV_ASSERT_OFFSET(desc, iov)                    \
> -       static_assert(offsetof(struct netmem_desc, desc) =3D=3D \
> -                     offsetof(struct net_iov, iov))
> -NET_IOV_ASSERT_OFFSET(_flags, _flags);
> -NET_IOV_ASSERT_OFFSET(pp_magic, pp_magic);
> -NET_IOV_ASSERT_OFFSET(pp, pp);
> -NET_IOV_ASSERT_OFFSET(_pp_mapping_pad, _pp_mapping_pad);
> -NET_IOV_ASSERT_OFFSET(dma_addr, dma_addr);
> -NET_IOV_ASSERT_OFFSET(pp_ref_count, pp_ref_count);
> -#undef NET_IOV_ASSERT_OFFSET
> -

Probably better to retain an assert that netmem_desc is the first
field in struct net_iov, no?

There technically is no assert that netmem_desc is the first field of
struct page, but it's generally well understood that the memory
descriptor types should be the first field of struct page. It's not
well understand that the netmem_desc type should be the first field in
struct net_iov though.

--
Thanks,
Mina

