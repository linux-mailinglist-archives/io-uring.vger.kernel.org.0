Return-Path: <io-uring+bounces-8846-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B800B143FF
	for <lists+io-uring@lfdr.de>; Mon, 28 Jul 2025 23:44:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B4575542378
	for <lists+io-uring@lfdr.de>; Mon, 28 Jul 2025 21:44:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67CAA275AE4;
	Mon, 28 Jul 2025 21:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lRlsCRH+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF575227E83
	for <io-uring@vger.kernel.org>; Mon, 28 Jul 2025 21:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753739074; cv=none; b=jUJTRMlnsygWd9URgL7BLsnK2RFJhgVLrqsr6bNRg87u3UL0ldkiS5xx/6rfY9IBmKENFH+u/cSk7M8XwMq/TxAvG59DFlWHe0CTT4qD0zPU272SE0UMAzdT4VjClMJQ1De4Jqh0peEdpdnqn9ZFA7ZLerNjEgSRQME1HdOHAxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753739074; c=relaxed/simple;
	bh=w4sz6hukx39VWGmuP3imtGw+JZjGSgr0C5Wb5CwNUl0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gBxyCq4mRUZqKGpGa3ne87qDhEZW3nPRz5exqPr6TWeHjXfsADy6qdJ4qMI8HGfT4+9erb5iygdt1GcDNoBmbCOKnrAdmQV035wb/0hA8QGJZ4z/WA3955Tjuwj1sWU6OifG3Trp1i98xjeqxUkm1zNH3gEbcIQnz52zb1OBnuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lRlsCRH+; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-237f18108d2so66275ad.0
        for <io-uring@vger.kernel.org>; Mon, 28 Jul 2025 14:44:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753739072; x=1754343872; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b5AX6jbpFgdSrCGPijdLxpXampkoJ36wfItC/35EtyM=;
        b=lRlsCRH+1CWLy2JzdV6wZ+V/yvI5JXwf6Zrw1fuqATsGKAW6pZy/oMDlC2XDxgUSea
         6+2H/utgKEIO1gGsM5g3k0ocOx5ZiHEqjF70xIwAwB2SeMF82wXtU0ATVpKTjUDA7bXu
         Q3Tf/jsyXgsyaZgx3Z7ccQwHYpERELeODhZWUb7OlbBOamiTLY5idGKGGsPDrW0F2nFY
         NtaUFmjGLhlu967R1zA1V83LmSbLyfM2EpIB+Dak0iDa4oQlfB0E4HDaykoyOgnw88n0
         ugINLWHaOqg/78aQOZptpcofNjs6KGU4k0hoYWbNVxQh7P2uWNTSnxSysqhbUeaWppVR
         Cnfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753739072; x=1754343872;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b5AX6jbpFgdSrCGPijdLxpXampkoJ36wfItC/35EtyM=;
        b=CB4+L1pR6YlqRKZWvZry8SpLYFpd0S0kNejhXne0XP/gPNq5/v2qbfA071EfNAAr4/
         UA90Me3XSJx+7jQ5lRl//TU2miBcO9LwelAdldpVZUIjhUqRYqzc0hWb9MdWpTJbi1xV
         WlUlvyJJcbKQZZYVybXjbLGpIcb+8NQvdCwlqj8DiAm+nm7AOWl5pwV1BmsHTmoGAzAH
         0UKhVwRmmMyJ41gx5Robj1WNDufRhBswbRDDGp+xDINpjQEPtKJ/Hne7dZvN6PvYn+t/
         E5PxS3XNYpyfEXI/HtmVDCllBWIm0JCFoM5180ye7/D2321ZX0pRQfI4p4qppioePsh/
         GeWQ==
X-Forwarded-Encrypted: i=1; AJvYcCU3jO7eoWPIe10gemUog0iC/mYlEf7QBLl48mtv2SgHErNYd8+NC7YYYyZ9/Z0EWVqjOu/XxDPOHw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxWAPnBP07wnlB3cv7Iv43iAZOSmq+YfxbS1xhRNkW75QGkYu5F
	xTfcfHBD3Sf4xm+F95bUGW34GW8iAZVlxCBKX00jJFLqTTHaPauu0/5vxmbp0AdGcJOUaHBey/G
	c5ODcJcWPOOabJbuZEW7UTjdNrw1xRuCBR4oyenG9F0T2DHFRdNfx54eJ
X-Gm-Gg: ASbGnctZy0rdMV/xnOiId+PQNeW5tY4Y2E7N9VT1xzUBM17YQuTzadjk9PeIDZooaRh
	ndPljblcZKjLxJZ24iAfLQq+4DsfQfVer9/tSMYZhYWRZwXqBbc3Deyb6L5NyVULtK7w13g4qwI
	KgCTENXOlzUx9EbCV4P9nzXWvYFqXAwdSxnc1fyagIAf42nG48lSRLG1XlhNVCiXxvZa9C2Um0U
	RZjf71RmuEgjNiqTO29ByKDPzlqgR11W6s8XA==
X-Google-Smtp-Source: AGHT+IFJpwta+wwoWzEy+vIV3DB1GRiqMFThaO5jO43VoC78NFg0WtFAfxgGrnZp+7Lje/EEFcMgVSD6KcGgtAsFGB4=
X-Received: by 2002:a17:903:948:b0:231:eedd:de3a with SMTP id
 d9443c01a7336-2406e9a0f15mr343595ad.25.1753739071634; Mon, 28 Jul 2025
 14:44:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1753694913.git.asml.silence@gmail.com> <d8409af4cfe922f663a2f8a7de5fc4881b7fa576.1753694913.git.asml.silence@gmail.com>
In-Reply-To: <d8409af4cfe922f663a2f8a7de5fc4881b7fa576.1753694913.git.asml.silence@gmail.com>
From: Mina Almasry <almasrymina@google.com>
Date: Mon, 28 Jul 2025 14:44:19 -0700
X-Gm-Features: Ac12FXwlu7sLqEGZjXVbKsY5cuCOfi7Gvi25bNgo6LZTErdChYFNFBD0pKpyBu8
Message-ID: <CAHS8izMAc+fTADD9Uzj-XssdSiUYt81U59+hYkB5b=4W9sGz8Q@mail.gmail.com>
Subject: Re: [RFC v1 04/22] net: clarify the meaning of netdev_config members
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org, io-uring@vger.kernel.org, 
	Eric Dumazet <edumazet@google.com>, Willem de Bruijn <willemb@google.com>, 
	Paolo Abeni <pabeni@redhat.com>, andrew+netdev@lunn.ch, horms@kernel.org, 
	davem@davemloft.net, sdf@fomichev.me, dw@davidwei.uk, 
	michael.chan@broadcom.com, dtatulea@nvidia.com, ap420073@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 28, 2025 at 4:03=E2=80=AFAM Pavel Begunkov <asml.silence@gmail.=
com> wrote:
>
> From: Jakub Kicinski <kuba@kernel.org>
>
> hds_thresh and hds_config are both inside struct netdev_config
> but have quite different semantics. hds_config is the user config
> with ternary semantics (on/off/unset). hds_thresh is a straight
> up value, populated by the driver at init and only modified by
> user space. We don't expect the drivers to have to pick a special
> hds_thresh value based on other configuration.
>
> The two approaches have different advantages and downsides.
> hds_thresh ("direct value") gives core easy access to current
> device settings, but there's no way to express whether the value
> comes from the user. It also requires the initialization by
> the driver.
>
> hds_config ("user config values") tells us what user wanted, but
> doesn't give us the current value in the core.
>
> Try to explain this a bit in the comments, so at we make a conscious
> choice for new values which semantics we expect.
>
> Move the init inside ethtool_ringparam_get_cfg() to reflect the semantics=
.
> Commit 216a61d33c07 ("net: ethtool: fix ethtool_ringparam_get_cfg()
> returns a hds_thresh value always as 0.") added the setting for the
> benefit of netdevsim which doesn't touch the value at all on get.
> Again, this is just to clarify the intention, shouldn't cause any
> functional change.
>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  include/net/netdev_queues.h | 19 +++++++++++++++++--
>  net/ethtool/common.c        |  3 ++-
>  2 files changed, 19 insertions(+), 3 deletions(-)
>
> diff --git a/include/net/netdev_queues.h b/include/net/netdev_queues.h
> index ba2eaf39089b..81df0794d84c 100644
> --- a/include/net/netdev_queues.h
> +++ b/include/net/netdev_queues.h
> @@ -6,11 +6,26 @@
>
>  /**
>   * struct netdev_config - queue-related configuration for a netdev
> - * @hds_thresh:                HDS Threshold value.
> - * @hds_config:                HDS value from userspace.
>   */
>  struct netdev_config {
> +       /* Direct value
> +        *
> +        * Driver default is expected to be fixed, and set in this struct
> +        * at init. From that point on user may change the value. There i=
s
> +        * no explicit way to "unset" / restore driver default.
> +        */

Does the user setting hds_thres imply turning hds_config to "on"? Or
is hds_thres only used when hds_config is actually on?

--=20
Thanks,
Mina

