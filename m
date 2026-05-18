Return-Path: <io-uring+bounces-13392-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eJ+EJ6j4CmoA+wQAu9opvQ
	(envelope-from <io-uring+bounces-13392-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 18 May 2026 13:31:52 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 544C756B96F
	for <lists+io-uring@lfdr.de>; Mon, 18 May 2026 13:31:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id BA2103041BB3
	for <lists+io-uring@lfdr.de>; Mon, 18 May 2026 11:24:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5FE23EFFBA;
	Mon, 18 May 2026 11:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="UtWNeIwt"
X-Original-To: io-uring@vger.kernel.org
Received: from mout.web.de (mout.web.de [212.227.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 442103D3CF9;
	Mon, 18 May 2026 11:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779103476; cv=none; b=WzFIu3VKTZiiaA8b4RKeRQt00L+j7aTrMeH/ojvhhy/ESKIaAzdTifFjnVPf+sLvKtRwKaeM21ukCnA90fMQ2JDu94zR9dS8Hsw0EuIPtwtRpLSgm0Lu2+qMyFCazLZxBePQqP3plM2QDbZhvC4dv1uGpaQQIdvfFyrJ0JOYugc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779103476; c=relaxed/simple;
	bh=XK0KKSSauxn/MYbQ/1zj7h0hSr8qJLlBxvbITOygI9o=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=rTGZcNj3dJ74TpqC/luGeLwjIcNCKtRK2XPOGXycDy6QqDzyBt2EzLEsQotw6MjdltK48/aFYNGVhEMftxF4MYAN55wg6C3Gd+RXuaJeufd8ETdWbSCTuMC3a1sv5E1kxJu4DenAu202UTdl1xi7x09GjgKE6Zw5JIg/xvvsufc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=UtWNeIwt; arc=none smtp.client-ip=212.227.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1779103468; x=1779708268; i=markus.elfring@web.de;
	bh=nMcXuM8rbRcq1h434qj3epfj8FYsmvo3X+4NIcO/AeY=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=UtWNeIwteHAyG+PDJFr1TVyr3K8w2z9a56O5Km7kzGUMYP498Jr77ox067lwbyNT
	 BJHIKkuFuj6i93TsLLJZmoFOyWyZGh2JXKSXDDvRYkLEDzPrN/8/v+V5AhrQ4KXqX
	 x0ttZbQ9H/osH5dY49E4WGthwuI0croI9RMKsTStrs9HGdUPx2sU+idWCZ8i/+fAp
	 iPdlLrtuWIByVa3NWI3yE2bYwkk9Ly1W1tDY3r8OTi+J5Z9/QSbFnaFreYCMaGMoT
	 +dS6CiwO4G6kGz+NgRmVh/bifAW5RF/VzeT+W9yYsV+BwISb4o6X8tVl8Mux4tID3
	 szP3CfBKYGkT3g5i8w==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from client.hidden.invalid by smtp.web.de (mrweb105
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MNOQy-1wi6Z41JP8-00OZDB; Mon, 18
 May 2026 13:24:28 +0200
Message-ID: <d97b79dc-24b8-446d-997a-d8a37b003363@web.de>
Date: Mon, 18 May 2026 13:24:24 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Pavel Begunkov <asml.silence@gmail.com>, linux-block@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-media@vger.kernel.org,
 io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
 linaro-mm-sig@lists.linaro.org, dri-devel@lists.freedesktop.org,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Andrew Morton <akpm@linux-foundation.org>,
 Christian Brauner <brauner@kernel.org>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
 Keith Busch <kbusch@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
 Sumit Semwal <sumit.semwal@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Anuj Gupta <anuj20.g@samsung.com>,
 Jason Gunthorpe <jgg@nvidia.com>, Kanchan Joshi <joshi.k@samsung.com>,
 Kees Cook <kees@kernel.org>, Nitesh Shetty <nj.shetty@samsung.com>,
 Phil Cayton <phil.cayton@intel.com>, Tushar Gohad <tushar.gohad@intel.com>,
 William Power <william.power@intel.com>
References: <c61e6d928f86f4cb253ae350272e6039faefd3a6.1777475843.git.asml.silence@gmail.com>
Subject: Re: [PATCH v3 05/10] lib: add dmabuf token infrastructure
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <c61e6d928f86f4cb253ae350272e6039faefd3a6.1777475843.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:ClnTC+RILrMOo7Arq+ysZiHvtRle/7V2w7AwdQsr0JleXzTN7HK
 LFG3yVXQ5ZWDJtLnKNJFaF0j9Q/2Zh01NNL7Uq6A/PFClJGlY0R59BgEoCw9EvvGPrml2ye
 6E6f45rrx+LDDjKioK8EErghlkfHVXDURUxpR5Cqzcul9Tox5YXYjMObkkjl/T39H2LtGWx
 RUsH12tLCyRdqcepJUh/Q==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:7DkAQz8NlEQ=;9+B13di3sT2nKmFwTLuEX89UtvK
 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
X-Rspamd-Queue-Id: 544C756B96F
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[web.de,quarantine];
	R_DKIM_ALLOW(-0.20)[web.de:s=s29768273];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13392-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FREEMAIL_TO(0.00)[gmail.com,vger.kernel.org,lists.infradead.org,lists.linaro.org,lists.freedesktop.org,zeniv.linux.org.uk,linux-foundation.org,kernel.org,amd.com,lst.de,kernel.dk,grimberg.me,linaro.org];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_FROM(0.00)[web.de];
	RCPT_COUNT_TWELVE(0.00)[26];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[Markus.Elfring@web.de,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[web.de:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[bootlin.com:url,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Action: no action

=E2=80=A6
> +++ b/lib/io_dmabuf_token.c
> @@ -0,0 +1,272 @@
=E2=80=A6
> +int io_dmabuf_init_map(struct io_dmabuf_token *token, struct io_dmabuf_=
map *map)
> +{
> +	struct io_dmabuf_fence *fence =3D NULL;
> +	int ret;
> +
> +	fence =3D kzalloc(sizeof(*fence), GFP_KERNEL);

How do you think about to use kzalloc_obj() instead?
https://elixir.bootlin.com/linux/v7.1-rc3/source/include/linux/slab.h#L103=
9-L1040


=E2=80=A6
> +	if (!fence)
> +		return -ENOMEM;
> +
> +	ret =3D percpu_ref_init(&map->refs, io_dmabuf_map_refs_release, 0, GFP=
_KERNEL);
> +	if (ret) {
> +		kfree(fence);
> +		return ret;
> +	}
=E2=80=A6

Would you like to use the attribute =E2=80=9C__free(kfree)=E2=80=9D?
https://elixir.bootlin.com/linux/v7.1-rc3/source/include/linux/slab.h#L517

Regards,
Markus

