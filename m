Return-Path: <io-uring+bounces-522-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BFE6B847A6A
	for <lists+io-uring@lfdr.de>; Fri,  2 Feb 2024 21:20:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A1D87B2BB76
	for <lists+io-uring@lfdr.de>; Fri,  2 Feb 2024 20:20:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF32C8062E;
	Fri,  2 Feb 2024 20:20:08 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from cloud48395.mywhc.ca (cloud48395.mywhc.ca [173.209.37.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09FE28060F;
	Fri,  2 Feb 2024 20:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.209.37.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706905208; cv=none; b=JnF9F9rwcFIJsPZvNjMyMfpfaYTm0cFdUY2R7WyTNYJA1doIrb3CDQ7NsX+0ZotnN0visB8psbjwvMgjzW4G6sMSNZztVXhQoLtSJmhGfQKGsDnd7U6utfoeI8WCe02xn8McbyH4nHlFPkaTQBALRE2kZD2RuN+V9RIVdELjztA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706905208; c=relaxed/simple;
	bh=Evn1w5AGptPF1Z63kSmh93Q8mPIcfW2DAXEfIIjINrM=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Ubw1+xLp4JoJmdAoCcLyE0pzez3Luvf9Nx95PMv7kugUSdIhTJRN4tbMIdapxT+UuH+YBBM74z/3YppXxYbav9K2PD8vA/SiganBXWYld0pSoWRhscNjQb7H+ZsC2di8JA8+j8LE4QDciZwX5rvmQRZ5FS4jUGg5saC63UFGDT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=trillion01.com; spf=pass smtp.mailfrom=trillion01.com; arc=none smtp.client-ip=173.209.37.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=trillion01.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trillion01.com
Received: from [45.44.224.220] (port=57996 helo=[192.168.1.177])
	by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96.2)
	(envelope-from <olivier@trillion01.com>)
	id 1rW017-0003tB-0c;
	Fri, 02 Feb 2024 15:20:05 -0500
Message-ID: <0ae91303c53aff4758bc07ee70add5c0f1ec524e.camel@trillion01.com>
Subject: Re: [PATCH v15 0/7] io_uring: add napi busy polling support
From: Olivier Langlois <olivier@trillion01.com>
To: Jens Axboe <axboe@kernel.dk>, Stefan Roesch <shr@devkernel.io>, 
	io-uring@vger.kernel.org, kernel-team@fb.com
Cc: ammarfaizi2@gnuweeb.org, netdev@vger.kernel.org, kuba@kernel.org
Date: Fri, 02 Feb 2024 15:20:04 -0500
In-Reply-To: <a0f5b96b-c876-4c0a-a7b5-3809c26077d6@kernel.dk>
References: <20230608163839.2891748-1-shr@devkernel.io>
	 <58bde897e724efd7771229734d8ad2fb58b3ca48.camel@trillion01.com>
	 <2b238cec-ab1b-4160-8fb0-ad199e1d0306@kernel.dk>
	 <45a21ffe4878d77acba01ec43005c80a83f0e31a.camel@trillion01.com>
	 <b6dc538a-01eb-4f87-a9d4-dea17235ff85@kernel.dk>
	 <34560e193660122ea142daa0fbeb381eb7b0eb6d.camel@trillion01.com>
	 <c28b3f5f40ed028ba9d74e94e3cc826c04f38bf7.camel@trillion01.com>
	 <a0f5b96b-c876-4c0a-a7b5-3809c26077d6@kernel.dk>
Autocrypt: addr=olivier@trillion01.com; prefer-encrypt=mutual;
 keydata=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
Organization: Trillion01 Inc
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.2 
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cloud48395.mywhc.ca
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - trillion01.com
X-Get-Message-Sender-Via: cloud48395.mywhc.ca: authenticated_id: olivier@trillion01.com
X-Authenticated-Sender: cloud48395.mywhc.ca: olivier@trillion01.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 

On Wed, 2024-01-31 at 13:52 -0700, Jens Axboe wrote:
> On 1/31/24 12:56 PM, Olivier Langlois wrote:
> > On Wed, 2024-01-31 at 12:59 -0500, Olivier Langlois wrote:
> > > On Wed, 2024-01-31 at 10:32 -0700, Jens Axboe wrote:
> > > >=20
> > > > Thanks for testing!
> > > >=20
> > > > Any chance that you could run some tests with and without NAPI
> > > > that
> > > > help
> > > > validate that it actually works? That part is what I'm most
> > > > interested
> > > > in, not too worried about the stability of it as I have
> > > > scrutinized
> > > > it
> > > > pretty close already.
> > > >=20
> > >=20
> > > There is maybe a test that I can perform. The data that I receive
> > > is
> > > timestamped. I have a small test program that checks the age of
> > > the
> > > updates on their reception...
> > >=20
> > > I would expect that it should be possible to perceive the busy
> > > polling
> > > effect by comparing the average update age with and without the
> > > feature
> > > enabled...
> > >=20
> > > A word of warning... The service that my client is connecting to
> > > has
> > > relocated recently. I used to have an RTT of about 8mSec with it
> > > to
> > > about 400-500 mSec today...
> > >=20
> > > because of the huge RTT, I am unsure that the test is going to be
> > > conclusive at all...
> > >=20
> > > However, I am also in the process of relocating my client closer
> > > to
> > > the
> > > service. If you can wait a week or so, I should able to do that
> > > test
> > > with a RTT < 1 mSec...
> > >=20
> > > Beside that, I could redo the same test that Stefan did with the
> > > ping
> > > client/server setup but would that test add any value to the
> > > current
> > > collective knowledge?
> > >=20
> > > I'll do the update age test when I restart my client and I'll
> > > report
> > > back the result but my expectations aren't very high that it is
> > > going
> > > to be conclusive due to the huge RTT.
> > >=20
> > >=20
> > As I expected, the busy polling difference in the update age test
> > is so
> > small compared to the RTT that the result is inconclusive, IMHO...
> >=20
> > The number of collected updates to build the stats is 500.
> >=20
> > System clocks are assumed to be synchronized and the RTT is the
> > difference between the local time and the update timestamp.
> > Actually, it may be more accurate to say that the displayed RTT
> > values
> > are in fact TT...
> >=20
> > latency NO napi busy poll:
> > [2024-01-31 11:28:34] INFO Main/processCollectedData rtt
> > min/avg/max/mdev =3D 74.509/76.752/115.969/3.110 ms
> >=20
> > latency napi busy poll:
> > [2024-01-31 11:33:05] INFO Main/processCollectedData rtt
> > min/avg/max/mdev =3D 75.347/76.740/134.588/1.648 ms
> >=20
> > I'll redo the test once my RTT is closer to 1mSec. The relative
> > gain
> > should be more impressive...
>=20
> Also happy to try and run it here, if you can share it? If not I have
> some other stuff I can try as well, with netbench.
>=20
I have redone my test with a fixed liburing lib that actually enable
io_uring NAPI busy polling correctly and I have slightly more
convincing result:

latency NO napi busy poll (kernel v7.2.3):
[2024-02-02 11:42:41] INFO Main/processCollectedData rtt
min/avg/max/mdev =3D 73.089/75.142/107.169/2.954 ms

latency napi busy poll (kernel v7.2.3):
[2024-02-02 11:48:18] INFO Main/processCollectedData rtt
min/avg/max/mdev =3D 72.862/73.878/124.536/1.288 ms

FYI, I said that I could redo the test once I relocate my client to
have a RTT < 1ms...

I might not be able to do that. I might settle for an AWS VPS instead
of a bare metal setup and when you are running the kernel on a VPS,
AFAIK, the virtual Ethernet driver does not have NAPI...


