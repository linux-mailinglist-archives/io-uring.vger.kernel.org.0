Return-Path: <io-uring+bounces-3465-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FCCC9949F8
	for <lists+io-uring@lfdr.de>; Tue,  8 Oct 2024 14:28:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 68551B2473B
	for <lists+io-uring@lfdr.de>; Tue,  8 Oct 2024 12:28:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2ADC01DED7B;
	Tue,  8 Oct 2024 12:27:52 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FC3C4C97;
	Tue,  8 Oct 2024 12:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390472; cv=none; b=lDKlQRa93gU0xLB0UPIcX+ZICb67IOyBS7eLrC7kUaQABfdSaVX/dIABB9fdLYm1qp0B8LH+FKXo+bGl0AZIU0sQGdHlrfz0W13Xfsq4tkunz5ZjbuoNW6bxiqv3psdE5t3e9K6Dpz5r3/dg9X13/bnRRff2ohDb0d8FzCutXx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390472; c=relaxed/simple;
	bh=3OWmEp1PuJE0qFBCqaixDxxjkUSmkqpnGOaPE6+Efxg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KFnRWFebjVoqlsrlRLdOvA1FLFEsAdAbw7sNqEs4pBTsBU9Lj2DLaYiu2uUH+SyPADO98BbckxWdLdC99b0keSm5Rxo192CghkmdVW1rmhAyOfkJA6T3iJ5phkyS/VQsz7SPuEriER1XSc6fDZfUVy+Dr6gvI5y8NGkCkI58Nes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 47343227A88; Tue,  8 Oct 2024 14:27:45 +0200 (CEST)
Date: Tue, 8 Oct 2024 14:27:45 +0200
From: Christoph Hellwig <hch@lst.de>
To: Javier =?iso-8859-1?Q?Gonz=E1lez?= <javier.gonz@samsung.com>
Cc: Christoph Hellwig <hch@lst.de>, Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Kanchan Joshi <joshi.k@samsung.com>, hare@suse.de, sagi@grimberg.me,
	brauner@kernel.org, viro@zeniv.linux.org.uk, jack@suse.cz,
	jaegeuk@kernel.org, bcrl@kvack.org, dhowells@redhat.com,
	asml.silence@gmail.com, linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
	linux-block@vger.kernel.org, linux-aio@kvack.org,
	gost.dev@samsung.com, vishak.g@samsung.com
Subject: Re: [PATCH v7 0/3] FDP and per-io hints
Message-ID: <20241008122745.GB29639@lst.de>
References: <20241002151949.GA20877@lst.de> <yq17caq5xvg.fsf@ca-mkp.ca.oracle.com> <a8b6c57f-88fa-4af0-8a1a-d6a2f2ca8493@acm.org> <CGME20241003125523eucas1p272ad9afc8decfd941104a5c137662307@eucas1p2.samsung.com> <20241003125516.GC17031@lst.de> <20241004062129.z4n6xi4i2ck4nuqh@ArmHalley.local> <20241004062415.GA14876@lst.de> <20241004065923.zddb4fsyevfw2n24@ArmHalley.local> <20241004123206.GA19275@lst.de> <20241007112931.afva6zzmipzdewm4@ArmHalley.local>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20241007112931.afva6zzmipzdewm4@ArmHalley.local>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Oct 07, 2024 at 01:29:31PM +0200, Javier González wrote:
>> That's not the point.  There is one company that drivers entirely pointless
>> marketing BS, and that one is pretty central here.  The same company
>> that said FDP has absolutely no іntent to work on Linux and fought my
>> initial attempt to make the protocol not totally unusable ony layer system.
>> And no, that's not Samsung.
>
> So you had an interaction in the working group, your feedback was not
> taking into consideration by the authors, and the result is that FDP
> cannot be supported in Linux as a consequence of that? Come on...

No, what I am saying is that the "small" FDP group that was doing the
development while keeping it doing away from the group insisted that
FDP is only for use in userspace drivers, and even getting the basis
in to properly make it suitable for a semi-multi tenant setup like
Linux io_uring passthrough was not welcome and actually fought tooth
and nail by the particular one particular company.  It a long talk to
the head of the NVMe board to even get this sorted out.

