Return-Path: <io-uring+bounces-5852-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DA5FA0FD36
	for <lists+io-uring@lfdr.de>; Tue, 14 Jan 2025 01:11:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 27BB2166029
	for <lists+io-uring@lfdr.de>; Tue, 14 Jan 2025 00:11:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D44B17FE;
	Tue, 14 Jan 2025 00:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YxqxM13d"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C3DF4A23;
	Tue, 14 Jan 2025 00:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736813514; cv=none; b=C7SP4jZkTiqBvWUMNEys0usb+nXWNMnY/2XkbZhfB5OrpMc5BBIwJ1CyaQqu74JGCJg8tt3KHtaOicG3mMLAo3YsJPenaT2aRihXZpjQmGCGpa/2BSlzk9bvIwZ9MhMyolOKwuSquNJXDq5CYhS2KDylTFfFmt/h3bfzq0LPhlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736813514; c=relaxed/simple;
	bh=L084qJu5dOb2JKaaqx/uddWn1hNRgC9R6NTUzNbXfU4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W91MLs2R3YqXLjwEbWJZ/MUft8fXrfrj50NZ8YW86mqJjzWcaZjpHNNcNi2CEp1IzX0z90lZ+BZDkSFQ+oVOykZaWtM+q4Au7wBqe0UVaILtSrXxGYLrnA3/Y+nq1Ac0YEC8kW1nuFAvE3/1HQM6CyV/5kXL4nJY0cuIHTPpo/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YxqxM13d; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-21649a7bcdcso83203275ad.1;
        Mon, 13 Jan 2025 16:11:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736813512; x=1737418312; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fIEAYx4Iaru+5nZG90gYHiCdSZAzHHpQuvX3nHkx7eg=;
        b=YxqxM13dJmOV6ijcWWGHYIoOMKJkI4suGesxsqAYLAjbYAuIS0TGaauOfNh/K6YKTh
         vylvcogPaDIjY7EU9U74p7vKG/Z1tfkIo5RCBsdfbmfwwaOpv3FWR98KLad2MwWnjtjZ
         +9L/ovhcWWoGXuLrLapdzvP0O9c8mPuxh9Ru1kpg+WBTTeLSVevngz3J3MpUByh4fTsl
         yLDJCE8jqN8ckqhrJbxPxLxhU0R7gU5LtC7VlvrQsQM/nqsDz6gXctpm1qpK0CC5MIEO
         BOw1leseq5EOEPVYJU41teUECptrWbJNkzGTmVU8fVJWde6xW+5VK9rXQ5q85a3u27U5
         Nv7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736813512; x=1737418312;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fIEAYx4Iaru+5nZG90gYHiCdSZAzHHpQuvX3nHkx7eg=;
        b=FOZ4Jchapl+XAyu2eLbQUW4QM8bm1sUL31YIVQJZTFAhYej99HxtCfRu7/56S1OAzX
         tFmfv+mPFUv9hax1m95whD+zBXNzWzBh32T2AEDLCq2Gv4mgmfmo5nQrKDYq/VkMcn4x
         AXhj6EfsO5pGRtIVlazG6e7HiiwCgo1a/+nE3qzZUBYXxapz/RrOILXU7a6z/tCgYoJi
         MYwwUmjN66Ep+bUPiSL1YOjlvVHvvk8V2N4b0b2nkgw8MspZXvv8Zp+jBoeJDoXzAnvI
         6OhL2AMLhw357I1d4n+Zc7BYe8zGwLlS6ar6AYJQjlppD0uxXsvlEfxDD9wHId3BA0jO
         ywfQ==
X-Forwarded-Encrypted: i=1; AJvYcCUD8Zo1qQK3vjsGFrg6Aa5FaV9/bFW21MW+XY8EB0StviUFtyMdHMfd+OKgjt8bJIl+FA0Lbk/+CA==@vger.kernel.org, AJvYcCV04t/xWApc0MK1qxWNQYRt+8vFrDFSHoemBNJCLUMzsYF4SO2igoFKzXDSSV4S0MArwCAH/cCY@vger.kernel.org
X-Gm-Message-State: AOJu0Ywgfy1HL58eFhsGxW6Gzbmz9Ax90vNSyZh8p9bLKOsUiD4TCd0l
	5UtmHhPKteBwq1a+fMZOgdDlJ8wFUSmfP9O+hKheEZRPo0u3p+LF/wgm
X-Gm-Gg: ASbGncuKjaaoVQ4BWsP7AclYeA1iV5mMR3bdf3H0WYvbLHOd/wc40C57X35ke2izBin
	MgrYt6TEZ/aSpkdpFu3w7NHnZ6Dw/L5OdA95o9TQJPWG62PfPQzlLMqf3KBKFLjtZrzMiG2pPWJ
	47yOGUL5EKLel87RPLgVNs7gYZoyiYw1clpteVjp3m1CZj6L57ia1MULErO9fuw/ZyOfgK6XUh0
	m0eMR7ocob+IAjGhGQkDT9ChycO+vM/Aq3ik3cgWHO4ihTHhWPpNHl9
X-Google-Smtp-Source: AGHT+IHaZgmeaFXUjCRQqcIz+w95EwiX/7Rslm/9T6lYywrbC6UkQWGSZv08IGJKAjC8ZFJ19FyEmw==
X-Received: by 2002:a17:903:41c3:b0:216:31c2:3db8 with SMTP id d9443c01a7336-21a83fc0665mr311282225ad.37.1736813512080;
        Mon, 13 Jan 2025 16:11:52 -0800 (PST)
Received: from localhost ([2601:646:9e00:f56e:123b:cea3:439a:b3e3])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21a9f130004sm58210665ad.80.2025.01.13.16.11.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jan 2025 16:11:51 -0800 (PST)
Date: Mon, 13 Jan 2025 16:11:50 -0800
From: Stanislav Fomichev <stfomichev@gmail.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org,
	netdev@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	David Ahern <dsahern@kernel.org>,
	Mina Almasry <almasrymina@google.com>,
	Joe Damato <jdamato@fastly.com>,
	Pedro Tammela <pctammela@mojatatu.com>
Subject: Re: [PATCH net-next v10 22/22] io_uring/zcrx: add selftest
Message-ID: <Z4WrxoAB6zv01GYR@mini-arch>
References: <20250108220644.3528845-1-dw@davidwei.uk>
 <20250108220644.3528845-23-dw@davidwei.uk>
 <Z4AIhGgAZPe8Ie-g@mini-arch>
 <a58b7f2a-2441-4e71-9f56-76f78d0180e4@davidwei.uk>
 <08bc45ec-93d4-4220-81d5-7377b3daa5cc@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <08bc45ec-93d4-4220-81d5-7377b3daa5cc@gmail.com>

On 01/13, Pavel Begunkov wrote:
> On 1/9/25 17:50, David Wei wrote:
> > On 2025-01-09 09:33, Stanislav Fomichev wrote:
> > > On 01/08, David Wei wrote:
> > > > Add a selftest for io_uring zero copy Rx. This test cannot run locally
> > > > and requires a remote host to be configured in net.config. The remote
> > > > host must have hardware support for zero copy Rx as listed in the
> > > > documentation page. The test will restore the NIC config back to before
> > > > the test and is idempotent.
> > > > 
> [...]
> > > > +
> > > > +		if (addr &&
> > > > +		    inet_pton(AF_INET6, addr, &(addr6->sin6_addr)) != 1)
> > > > +			error(1, 0, "ipv6 parse error: %s", addr);
> > > > +		break;
> > > 
> > > nit: let's drop explicit af_inet support and use dual-stack af_inet6 sockets
> > > explicitly? Take a look at parse_address in
> > > tools/testing/selftests/drivers/net/hw/ncdevmem.c on how to
> > > transparently fallback to v4 (maybe even move that parsing function into
> > > some new networking_helpers.c lib similar to bpf subtree?).
> > > 
> > > (context: pure v4 environments are unlikely to exist at this point;
> > > anything that supports v6 can use v4-mapped-v6 addresses)
> > > 
> > > > +	default:
> > > > +		error(1, 0, "illegal domain");
> > > > +	}
> > > > +
> > > > +	if (cfg_payload_len > max_payload_len)
> > > > +		error(1, 0, "-l: payload exceeds max (%d)", max_payload_len);
> > > > +}
> > > > +
> ...
> > > [..]
> > > 
> > > > +def _get_rx_ring_entries(cfg):
> > > > +    eth_cmd = "ethtool -g {} | awk '/RX:/ {{count++}} count == 2 {{print $2; exit}}'"
> > > > +    res = cmd(eth_cmd.format(cfg.ifname), host=cfg.remote)
> > > > +    return int(res.stdout)
> > > > +
> > > > +
> > > > +def _get_combined_channels(cfg):
> > > > +    eth_cmd = "ethtool -l {} | awk '/Combined:/ {{count++}} count == 2 {{print $2; exit}}'"
> > > > +    res = cmd(eth_cmd.format(cfg.ifname), host=cfg.remote)
> > > > +    return int(res.stdout)
> > > > +
> > > > +
> > > > +def _set_flow_rule(cfg, chan):
> > > > +    eth_cmd = "ethtool -N {} flow-type tcp6 dst-port 9999 action {} | awk '{{print $NF}}'"
> > > > +    res = cmd(eth_cmd.format(cfg.ifname, chan), host=cfg.remote)
> > > > +    return int(res.stdout)
> > > 
> > > Most of these (except installing flow steering rule) can be done over
> > > ethtool ynl family. Should we try to move them over to YNL calls instead
> > > of shelling out to ethtool binary? There are some examples in rss_ctx.py
> > > on how to work with ethtool spec.
> > > 
> > > Same for setting/resetting number of queues below.
> > 
> > I wanted to use YNL, but these commands are run on the remote host and
> > it's currently challenging to use YNL there.
> > 
> > > 
> > > For the rest, there is also a ethtool() wrapper so you don't have to
> > > do cmd("ethtool ...") and can do ethtool("...").
> > 
> > SG, I will update to use ethtool() helper.
> 
> If there will be no more issues / concerns, I'd assume we can merge
> this series and follow up on top, as it rather sounds like an
> improvement but not a real problem. Stan, does it work for you?

Sure, can be fixed separately.

