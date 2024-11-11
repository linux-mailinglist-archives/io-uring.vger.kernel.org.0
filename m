Return-Path: <io-uring+bounces-4600-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5620C9C3B1D
	for <lists+io-uring@lfdr.de>; Mon, 11 Nov 2024 10:42:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 03C6E1F21DEF
	for <lists+io-uring@lfdr.de>; Mon, 11 Nov 2024 09:42:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC7F0143C72;
	Mon, 11 Nov 2024 09:42:49 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A30A9146A68;
	Mon, 11 Nov 2024 09:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731318169; cv=none; b=MroHxAVVxldcKL+dyFEPCJ74M7S8a8hM68+nMXaeTGB8SCuAQliiX+Hx8gK+/RdBnOrN7suI0CAizfH3MN+O//HPbHPbLGVP6Lr2ngu5sCajWj+ZtreS8LFXuvn1MmXMmM4VluEsRacoTFEgsLdYynTo1VZFkKG1FHvS4Y/GACw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731318169; c=relaxed/simple;
	bh=v099hRsyDNUvAYjxqPyiUxYilVKM5wWdcMizVKXaUas=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O0tGNJX3HK1VQdCn0dGmljqlMB206QUVA3n15zYjD8uxuMWSFT9uve8rVCzI56owrUC6l1mMeChETAeiuAhvDP+lVQRMD2+rlSQGAatQfTjPR3QP0gGhlDTiMBQXsbDPprp6VFwFtb/e94q6f5MA+3w0CeIDcopq/ObIWK53Oo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5E2E868D05; Mon, 11 Nov 2024 10:42:42 +0100 (CET)
Date: Mon, 11 Nov 2024 10:42:42 +0100
From: hch <hch@lst.de>
To: Javier Gonzalez <javier.gonz@samsung.com>
Cc: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>, hch <hch@lst.de>,
	Matthew Wilcox <willy@infradead.org>,
	Keith Busch <kbusch@kernel.org>, Keith Busch <kbusch@meta.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"joshi.k@samsung.com" <joshi.k@samsung.com>,
	"bvanassche@acm.org" <bvanassche@acm.org>
Subject: Re: [PATCHv10 0/9] write hints with nvme fdp, scsi streams
Message-ID: <20241111094241.GA27090@lst.de>
References: <Zy0k06wK0ymPm4BV@kbusch-mbp> <20241108141852.GA6578@lst.de> <Zy4zgwYKB1f6McTH@kbusch-mbp> <CGME20241108165444eucas1p183f631e2710142fbbc7dee9300baf77a@eucas1p1.samsung.com> <Zy5CSgNJtgUgBH3H@casper.infradead.org> <d7b7a759dd9a45a7845e95e693ec29d7@CAMSVWEXC02.scsc.local> <20241111065148.GC24107@lst.de> <20241111093038.zk4e7nhpd7ifl7ap@ArmHalley.local> <81a00117-f2bd-401c-b71e-1c35a4459f9a@wdc.com> <20241111094133.5qvumcbquxzv7bzu@ArmHalley.local>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241111094133.5qvumcbquxzv7bzu@ArmHalley.local>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Nov 11, 2024 at 10:41:33AM +0100, Javier Gonzalez wrote:
> You are right. Sorry I forgot.
>
> Would this be through copy_file_range or something different?

Just like for f2fs, nilfs2, or the upcoming zoned xfs the prime user
would be the file system GC code.

