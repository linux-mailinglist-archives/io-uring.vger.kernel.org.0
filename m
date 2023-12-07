Return-Path: <io-uring+bounces-256-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F142A808F0C
	for <lists+io-uring@lfdr.de>; Thu,  7 Dec 2023 18:49:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2E40F1C2031E
	for <lists+io-uring@lfdr.de>; Thu,  7 Dec 2023 17:49:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BB204B127;
	Thu,  7 Dec 2023 17:49:01 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73B8E170C;
	Thu,  7 Dec 2023 09:48:58 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1A0D5227A87; Thu,  7 Dec 2023 18:48:54 +0100 (CET)
Date: Thu, 7 Dec 2023 18:48:53 +0100
From: Christoph Hellwig <hch@lst.de>
To: Ming Lei <ming.lei@redhat.com>
Cc: Keith Busch <kbusch@kernel.org>, Jeff Moyer <jmoyer@redhat.com>,
	Keith Busch <kbusch@meta.com>, linux-nvme@lists.infradead.org,
	io-uring@vger.kernel.org, axboe@kernel.dk, hch@lst.de,
	sagi@grimberg.me, asml.silence@gmail.com,
	linux-security-module@vger.kernel.org,
	Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: [PATCH 1/2] iouring: one capable call per iouring instance
Message-ID: <20231207174853.GA31395@lst.de>
References: <20231204175342.3418422-1-kbusch@meta.com> <x49zfypstdx.fsf@segfault.usersys.redhat.com> <ZW4hM0H6pjbCpIg9@kbusch-mbp> <ZW6jjiq9wXHm5d10@fedora> <ZW6nmR2ytIBApXE0@kbusch-mbp> <ZW60WPf/hmAUoxPv@fedora> <ZW9FhsBXdPlN6qrU@kbusch-mbp> <ZW/loVJu0+11+boh@fedora> <ZXCT6mpt2Tq0k-Nw@kbusch-mbp> <ZXEeei6eoDW87xcN@fedora>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZXEeei6eoDW87xcN@fedora>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Dec 07, 2023 at 09:23:06AM +0800, Ming Lei wrote:
> Got it, thanks for the explanation, and looks one big defect of
> NVMe protocol or the device implementation.

It is.  And NVMe has plenty more problems like that and people keep
adding this kind of crap even today :(

