Return-Path: <io-uring+bounces-12540-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qGzLC+NFpmlyNQAAu9opvQ
	(envelope-from <io-uring+bounces-12540-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 03 Mar 2026 03:22:27 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 858F31E7F63
	for <lists+io-uring@lfdr.de>; Tue, 03 Mar 2026 03:22:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 228013069D07
	for <lists+io-uring@lfdr.de>; Tue,  3 Mar 2026 02:22:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57892374E63;
	Tue,  3 Mar 2026 02:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S4c03HEX"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33450374E55;
	Tue,  3 Mar 2026 02:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772504544; cv=none; b=Wt3KlZweZf8RP3oTBXoqKHB7tzjj0YvJKIM9Iu0T6J7noGz0cjzyPoqukY1nxRqd2jq3DEDBFFZyhmamKQ19Luar3tSEJ8dPnsIsDrPykbDLjJJ9I62RtGO34pynIRrUyQ6LbFZv4NtWG/i2SiliQQqqU9giFSrGEy/BEdjSwiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772504544; c=relaxed/simple;
	bh=FuRaYsMjsWLZvOk//t1aFOvZNRFRtW4K4jW4O/JqU04=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nOiWufr5Nnzgd8lKoUqpyZzBh7N6M0odhmJPG7dKggMbXUAaDOtJmh/tDFI87knxi/z6LT05xzedmqWYb8Ya0b5biqp29zXvOqfZXlQQTAV4zQ1V6za8ZLP3QxrEaEd4onhvvxnUJ+d2zl+ZpDiK6r1HNCdK9Lzj24kJeCSo6e4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S4c03HEX; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 493D3C19423;
	Tue,  3 Mar 2026 02:22:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772504543;
	bh=FuRaYsMjsWLZvOk//t1aFOvZNRFRtW4K4jW4O/JqU04=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=S4c03HEXokUtHIW4O9wVWNYrPWhNl4tU4AGHNhFIejFgKY29R9cT0nC6D2NBTmclx
	 5FcF4Je1jncW6Vzic2j4h6sX3NR+dvrZIhuZCe+uULrHTsBSml7D7Hg0a9wyC8IIcu
	 u6Fw6C24m8DoiWKtOA9K0N2QdHW9MLA88TwGq9CF65mxLesblK7lYA5ecEjclj3wjO
	 l7+gu6/Iiiqnt2iQpGkZjxXRr3wtR7OSVXUCiF7FKrh/8oG4NKHA0aG3YqswyTU8U6
	 VV7nlsNf/MMlBmojvmZN3lxlMFXHXTSaX2LvA51dJULNa1LvMEH6El0K1rKYRnLR4Q
	 BL1qsS6aGIJDQ==
Date: Mon, 2 Mar 2026 18:22:22 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Dragos Tatulea <dtatulea@nvidia.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
 pabeni@redhat.com, andrew+netdev@lunn.ch, horms@kernel.org, dw@davidwei.uk,
 jdamato@fastly.com, asml.silence@gmail.com, io-uring@vger.kernel.org,
 shuah@kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH net-next 3/3] selftests: drv-net: iou-zcrx: allocate
 hugepages for large chunks test
Message-ID: <20260302182222.245a34d0@kernel.org>
In-Reply-To: <f827a42a-be8d-46ea-a6f8-edf0f1ee1a26@nvidia.com>
References: <20260227171305.2848240-1-kuba@kernel.org>
	<20260227171305.2848240-4-kuba@kernel.org>
	<f827a42a-be8d-46ea-a6f8-edf0f1ee1a26@nvidia.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 858F31E7F63
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12540-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[davemloft.net,vger.kernel.org,google.com,redhat.com,lunn.ch,kernel.org,davidwei.uk,fastly.com,gmail.com];
	RCPT_COUNT_TWELVE(0.00)[13];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.997];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kuba@kernel.org,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring,netdev];
	TO_DN_SOME(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Mon, 2 Mar 2026 16:16:38 +0100 Dragos Tatulea wrote:
> > +    hp_file = "/proc/sys/vm/nr_hugepages"
> > +    with open(hp_file, 'r+', encoding='utf-8') as f:
> > +        nr_hugepages = int(f.read().strip())
> > +        if nr_hugepages < 64:
> > +            f.seek(0)
> > +            f.write("64")
> > +            defer(lambda: open(hp_file, 'w', encoding='utf-8').write(str(nr_hugepages)))
> > +
> >      single(cfg)
> >      rx_cmd = f"{cfg.bin_local} -s -p {cfg.port} -i {cfg.ifname} -q {cfg.target} -x 2"
> >      tx_cmd = f"{cfg.bin_remote} -c -h {cfg.addr_v['6']} -p {cfg.port} -l 12840"
> >  
> >      probe = cmd(rx_cmd + " -d", fail=False)
> >      if probe.ret == SKIP_CODE:
> > -        raise KsftSkipEx(probe.stdout)
> > +        raise KsftSkipEx(probe.stdout.strip())
> >    
> While working on a similar fix I found that the probe here also requires a barrier.

Hm, I'm not hitting this issue. Maybe because I'm testing in QEMU?
If you can still repro after this series could you send a follow up?

