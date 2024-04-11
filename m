Return-Path: <io-uring+bounces-1509-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C84928A19F5
	for <lists+io-uring@lfdr.de>; Thu, 11 Apr 2024 18:28:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 83FE42842E6
	for <lists+io-uring@lfdr.de>; Thu, 11 Apr 2024 16:28:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D064C1BED83;
	Thu, 11 Apr 2024 15:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="xaU2NKBL"
X-Original-To: io-uring@vger.kernel.org
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF5271BF6CC;
	Thu, 11 Apr 2024 15:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712849872; cv=none; b=mjjDqrDpYXNffbR9K/hmYohjcpjYafnqAEdBeCOnVTmO7v03soVaWtxtXA7eXY9eYtFD9xDv71kf36lVuofp0m6Tfc0TRDem/GFiHIEiJYW+IYkvs2YqL448Los7kai76d9036i3eFVkzrkJm03E0wOQq5zqGc4ifx7Dhv4JSHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712849872; c=relaxed/simple;
	bh=WE1dyOcRCkdDKHVQSE8grhwnH0jVKprFA2u7hDTWTaw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=VLu35FTtkolSraV1i8RltDV5hoSRbmBL7w3KUce111GrBzSmfzBXtEBl1d4kLJx0d7cnT4tXGu3Q3LRVLZPQVWQ67+AO0OlC+xzxaVc9sG1JxLATF59r97aWz+oxpK5gd0qkbSAJQ3IssufWTmvDAugY3WyCNhetNL1jjJcKNxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=xaU2NKBL; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=WE1dyOcRCkdDKHVQSE8grhwnH0jVKprFA2u7hDTWTaw=;
	t=1712849869; x=1714059469; b=xaU2NKBLgr7Yn2tBHn2ek+3yEF9AP7G0ybp9rH/bKy0MrDs
	EakNHnrWExF3wu5+mAsO/bYs+RlbF/ypk3VKmFlsyDGTccEuCmu5mq9b3zXV5P6Rupkl9hO5aQoeV
	AS2hYnG07ZFPQGesyfbZPKg13eQbyk+3XEj0iFBJqK/xt4DwkAWiTQa/PshMGcBTbKDVUyyqrsvCV
	0bzqmEXkxPlzdq6cRG7OCU3ogUg2p6kA3KDnndD1P/X2oLebFI0M8027Tfmn9kR804FHBFRFE9U7N
	Z2ptAqRr9jcIRRli1XQxtl7jx7vyHLDBVb+LTWNNiLlzJmMotq02CucNtbtfwdAA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.97)
	(envelope-from <johannes@sipsolutions.net>)
	id 1ruwUh-00000002nXW-0s48;
	Thu, 11 Apr 2024 17:37:43 +0200
Message-ID: <d2a0cf345c7e049ffd76acd315e6b377d94a344c.camel@sipsolutions.net>
Subject: Re: [PATCH] treewide: Fix common grammar mistake "the the"
From: Johannes Berg <johannes@sipsolutions.net>
To: Thorsten Blum <thorsten.blum@toblux.com>, kernel-janitors@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 linux-s390@vger.kernel.org, speakup@linux-speakup.org, 
 intel-gfx@lists.freedesktop.org, intel-xe@lists.freedesktop.org, 
 dri-devel@lists.freedesktop.org, linux-wireless@vger.kernel.org, 
 linux-scsi@vger.kernel.org, linux-afs@lists.infradead.org, 
 ecryptfs@vger.kernel.org, netfs@lists.linux.dev,
 linux-fsdevel@vger.kernel.org,  linux-unionfs@vger.kernel.org,
 linux-arch@vger.kernel.org,  io-uring@vger.kernel.org, cocci@inria.fr,
 linux-perf-users@vger.kernel.org
Date: Thu, 11 Apr 2024 17:37:41 +0200
In-Reply-To: <20240411150437.496153-4-thorsten.blum@toblux.com>
References: <20240411150437.496153-4-thorsten.blum@toblux.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.4 (3.50.4-1.fc39) 
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

On Thu, 2024-04-11 at 17:04 +0200, Thorsten Blum wrote:
> Use `find . -type f -exec sed -i 's/\<the the\>/the/g' {} +` to find all
> occurrences of "the the" and replace them with a single "the".

I estimated that this misses at least ~50 instances split across lines:

$ git grep -ih -A1 -e 'the$'|grep -vi 'the$'|grep -E -- '^[^a-zA-Z0-9]*the =
'|wc -l
51

And a bunch that have more than one space:

$ git grep -E '\<the\s\s+the\>'|wc -l
20

So not sure you should claim "all" ;-)

johannes

