Return-Path: <io-uring+bounces-1570-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AA4118A65CC
	for <lists+io-uring@lfdr.de>; Tue, 16 Apr 2024 10:13:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 60D2128145E
	for <lists+io-uring@lfdr.de>; Tue, 16 Apr 2024 08:13:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 034EF12837B;
	Tue, 16 Apr 2024 08:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="DjfBfnCe"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 889CD8665B;
	Tue, 16 Apr 2024 08:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.118.77.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713255235; cv=none; b=Bo/VO32gKEp/cQNXWiOm70qcDMlA02cenALcE6z6l2oQq1bn8M0loXAOsQkcvLLCNhQWf17j2nMruLHfHxedMt9sENrLUe+88n6R+ELmzat6/l3rncBx3nfmmZW4llL3weF7YqcnQo00IlGcIvPC165G7yKRDcrCuTVElOAvP8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713255235; c=relaxed/simple;
	bh=YqgOG9P2hP+Vazd20A7MBz6h2MRJHFt4LF2ghAPYO2E=;
	h=Date:From:To:CC:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To:References; b=k21OssrUmmuuo1y9eotbeHsjvdyJUkxEdiQ8UBShV4sw94s4UGOCFhnw3oRXRtKujCnYTzPAnMxWjwin+unHVYl5rbHJhOdR3sAQDpGbgV1dwEHq2/ggtoCBQIfO1cnPytLQtA6087WaK6+RbW28B0PjgLxiZYE6KpZ8mvaF6hc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=DjfBfnCe; arc=none smtp.client-ip=210.118.77.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20240416081348euoutp01e986ae0c0420cbaa6fc619f69deca38c~GtI2QdGVB1646716467euoutp01L;
	Tue, 16 Apr 2024 08:13:48 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20240416081348euoutp01e986ae0c0420cbaa6fc619f69deca38c~GtI2QdGVB1646716467euoutp01L
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1713255228;
	bh=bIsb30PZaSLB5OiZcM1+QbJIYYQGcYX6Ld4HuDawoik=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=DjfBfnCeczMwC9VGzREMUcny6hjKUIOJoo9UY/piJvcw7sh4r6U0qajsOpPBvf5/a
	 Am3tENqHGcwHVkdAyNnMNbfN0nb5zgR2HXcAz+cdr5eruKji3XZlXhuBFe53cTSFKr
	 W7mDC4fAmyjv0YJa7FWCt6cSAqXOWsc+9rtiMLp4=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTP id
	20240416081348eucas1p21cb60b08f416405e6a309e4ef595fa28~GtI1_WOdJ1606116061eucas1p26;
	Tue, 16 Apr 2024 08:13:48 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
	eusmges3new.samsung.com (EUCPMTA) with SMTP id D9.06.09620.B333E166; Tue, 16
	Apr 2024 09:13:47 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20240416081347eucas1p2328252cc35f468c42c0954eaa09d59eb~GtI1f3yuF1895218952eucas1p2U;
	Tue, 16 Apr 2024 08:13:47 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
	eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240416081347eusmtrp140e4080a0a0dac1890e78f8bb14248ff~GtI1dsrEb2457724577eusmtrp1W;
	Tue, 16 Apr 2024 08:13:47 +0000 (GMT)
X-AuditID: cbfec7f5-d1bff70000002594-a1-661e333b54e0
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
	eusmgms2.samsung.com (EUCPMTA) with SMTP id 18.75.09010.B333E166; Tue, 16
	Apr 2024 09:13:47 +0100 (BST)
Received: from CAMSVWEXC02.scsc.local (unknown [106.1.227.72]) by
	eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240416081347eusmtip12c7c7c247154a41e8dc385754f42215a~GtI1M5Wo13269232692eusmtip1G;
	Tue, 16 Apr 2024 08:13:47 +0000 (GMT)
Received: from localhost (106.210.248.128) by CAMSVWEXC02.scsc.local
	(2002:6a01:e348::6a01:e348) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
	Tue, 16 Apr 2024 09:13:46 +0100
Date: Tue, 16 Apr 2024 09:53:36 +0200
From: Joel Granados <j.granados@samsung.com>
To: Paul Moore <paul@paul-moore.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Muchun Song
	<muchun.song@linux.dev>, Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi
	<naoya.horiguchi@nec.com>, John Johansen <john.johansen@canonical.com>,
	James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>,
	David Howells <dhowells@redhat.com>, Jarkko Sakkinen <jarkko@kernel.org>,
	Kees Cook <keescook@chromium.org>, Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>, Jens Axboe <axboe@kernel.dk>, Pavel
	Begunkov <asml.silence@gmail.com>, Atish Patra <atishp@atishpatra.org>, Anup
	Patel <anup@brainfault.org>, Will Deacon <will@kernel.org>, Mark Rutland
	<mark.rutland@arm.com>, Paul Walmsley <paul.walmsley@sifive.com>, Palmer
	Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, Luis
	Chamberlain <mcgrof@kernel.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
	<apparmor@lists.ubuntu.com>, <linux-security-module@vger.kernel.org>,
	<keyrings@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<io-uring@vger.kernel.org>, <linux-riscv@lists.infradead.org>,
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 2/7] security: Remove the now superfluous sentinel
 element from ctl_table array
Message-ID: <20240416075336.stuemtkatjdz4rqe@joelS2.panther.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="zfniyufgrrisfuqi"
Content-Disposition: inline
In-Reply-To: <CAHC9VhT1ykCKnijSbsgPXO9o-5_LHAtSm=q=cdQ8N9QH+WA+tw@mail.gmail.com>
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
	CAMSVWEXC02.scsc.local (2002:6a01:e348::6a01:e348)
X-Brightmail-Tracker: H4sIAAAAAAAAA1WTfVBUVRjGO/eevXdBgctHcUCzXKQUFGyIPKOSMCrdP/zDoqYxJnODKzDC
	wuyKkdEItNIuH4Igs7au8ikou4EtsCpiEQlCIggkrMQugW7Fp8iHRNtgbBfL/vs97/s8M897
	Zo6QdHlCeQpjJIc5qUQcK6LsoaFloWPTtoA1Bzf/2rcFa6p1FJZPTQpwnVVN49SWIgHWVBoA
	VnSEYq0ph8KaTjnEk2lWiDNHV+PJ4x0Q5y3kAlxVXUrg1tnjFG7PjMN1A2kUVs6fh1h/v1eA
	B80LBG643gZxT72GwmbdEwE2zMgpPJU1TOHzfV0ENuZaAC6/OgRxV2ojwCM9WSROVzvhn/NU
	EHfe6aCxfCAweC2rO6cDbK/iG8gWWNshq07JptgzKV2QHR8ZgWztxXsE+4Nilmavqk00a2j0
	Znuv7WPlNyYEbM/tRFZfqaRY/XQezbaetsK9Hh/Yb4/kYmOOcFL/Nw/YR2dOyImEbKeka3Ny
	IgVMr8wAdkLEvI7qzUoyA9gLXZgLAPW1DVO8mAWoK/Ux5MUMQH+11hBPI/ON3TS/qABo4Pb3
	1L+umeIbAl7UAVSY3QJtEch4o0nDCGljitmIOscH/mE3Zh0qtVQDG5NMoR1q/jrGxq4Mh+aV
	nZSNHZhgpMo9KeDZGbV99QDy/iR0vfn+EguXeBWqWBTa0I55G/2RxfBFvVDacJmA58/Rj7X9
	hK0aYk6tQKbC9OXFLpR71wh5dkWjN2tpnlejW/lZkA/kA/Td4hTNCy1A5alzy2+xDcl/erCc
	CEE5f+oEthaIcUTGCWe+pyPKM6hIfuyAFOkuvPsVpDWPw1zgpX7mMvUzl6n/u4zHDai63v9/
	U5vZF5UXj5E8B6GqqoewCNCVwJ1LlMVFcbIACfeJn0wcJ0uURPlFxMfpwdK/uLV4c+4KuDD6
	yK8JEELQBNYthYcvae8ATyiJl3AiNwe564sHXRwixZ8e5aTxH0kTYzlZE1glhCJ3B+/IlzgX
	Jkp8mDvEcQmc9OmWENp5phDvzEZt3Kr9bZNkopjMnJ0ym77ITl5vfW775SBL6bHwiApLWdDY
	LxEPvUK6Q5nPRkP0ycSXDW2qoaEwUcKezYPRRSWPj5xs1pcwZFpTXfDLpNZpPGil4/r3usL0
	SBYWSM1EtkV/23k3y/joqNKDe0twdj51Q8jg1v72feFKY8GhAxMnnqeNSWaf0/kvSKpMOwfm
	h/yDfUtO0GyY3bvuY9M71vQrM1pnYk7VuJ/dD+5d7rAPf0M4new4/THrI67Z0uMbVBX1amhE
	Q5/zlWiPvTpF/Ic7QsMvWQJ81Wuz2/cPZ2pWuDlfVHkk7vp99zFloDWnSEmY4lRJBbsrFf5N
	ZcXv7+kWQVm0+DUfUioT/w3sC6XnkgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA2WSbUxTVxiAc3pvb1szxl0p41iVQQXNYBRaKB6QEseSefWHDMiybMBYA7eA
	0hb74cY2F8TCgGJWiAbXNcKGhYEEhEAjc4sMFxSElo+AcxQWUDBFRJxExAqs0C0z2b/nvB/P
	++bkZWNcM8Fn5yq1tFopyxMQ2/Bb6zcmw/ZH+ssjOs74IXNrM4H0S4tM1OkysdCp3lomMjdZ
	ASq1vYsuTX5DILNdj6PFIheODPM70WKxDUdVq0aAWlrrGOjmcjGBBgwK1OkoIlDZigVH7XfH
	mejPqVUG+vmXPhyN/mQm0FTzBhNZn+gJtFQxQyDL7WEG+t04C1B91zSOhk91A+QcrcBQickb
	TVRV48g+ZGMhvUNyIJBqvtAMqPHSNpw65xrAKVPhGYL6rnAYpxacTpzqaLzDoK6XLrOoLtMk
	i7J2B1PjVz+k9L89ZFKjgzqqvamMoNr/qmJRN8+78Pe2fySMU6t0WjogR6XRSgWpIiQWimKQ
	UBwVIxRF7kuPFUsE4fFxWXRe7glaHR7/iTDn/rVFLN/g/VlXDa8QLL1SDjhsSEbBle4RVjnY
	xuaSFgBLr/YRnsRO2LY8xvSwD3wxXk54ih4DOL1mwjyPTgAnvl7GN6twMhguWp3YJhPkW9C+
	4NhiHhkE62ZbwWYDRtZw4IOuwS2tD0nDlTL71jgv8gCsNlYyPdZ6DLZ1FgJP4jXY9+29rQkY
	eQL2N/e4rWw374AN6+xN5JBJ8FkF6dl0NyyaufjP1ifhk7U5YAQ+ppdEppdEpv9EnvBe+OLC
	yP/DobD++weYh6WwpeURXgtYTYBH6zSKbIVGLNTIFBqdMluYqVK0A/dpWntXO66AxvnHwh7A
	YIMeEOTunLl8aQjwcaVKSQt4XnqfXXKuV5as4HNarcpQ6/JoTQ+QuH+xEuP7Zqrcd67UZoii
	IySiqOiYCElMdKTAz+tQfqmMS2bLtPQxms6n1f/2MdgcfiGjZuRgdpyjsvaN7csnMx3Pn6XP
	cVPuWn9th0cXDtZZshpe95N4BdhW9xy22YPjGMf0az8MKnM+vciXPsJ2DIWNpHGS/phZOU7a
	05PW/davBDSk7sl2vb+voqVE0ZtQHHtt/5Gze2efHr8/JZYaePKVRE7o6YxkueOGI7ZoY+rj
	8FjX00NBIe8UXLeGGjZWv8q99eVt//w034LGkqW0DNv0wFD887bilIcVvBFHSpOxNbkkskr2
	BU8eVkl3wMRX55x3TGNs/5AsnU9CdbX6vNXCCowXefu+3S8/fMTCT3pzgnfUeU6qTZQuGO71
	X07OEvYOnN7N25UwJk6dPzv945T5g0ABrsmRiUIwtUb2Ny6p+ksvBAAA
X-CMS-MailID: 20240416081347eucas1p2328252cc35f468c42c0954eaa09d59eb
X-Msg-Generator: CA
X-RootMTR: 20240328155911eucas1p23472e0c6505ca73df5c76fe019fdd483
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20240328155911eucas1p23472e0c6505ca73df5c76fe019fdd483
References: <20240328-jag-sysctl_remset_misc-v1-0-47c1463b3af2@samsung.com>
	<CGME20240328155911eucas1p23472e0c6505ca73df5c76fe019fdd483@eucas1p2.samsung.com>
	<20240328-jag-sysctl_remset_misc-v1-2-47c1463b3af2@samsung.com>
	<20240415134406.5l6ygkl55yvioxgs@joelS2.panther.com>
	<CAHC9VhTE+85xLytWD8LYrmdV8xcXdi-Tygy5fVvokaLCfk9bUQ@mail.gmail.com>
	<CAHC9VhT1ykCKnijSbsgPXO9o-5_LHAtSm=q=cdQ8N9QH+WA+tw@mail.gmail.com>

--zfniyufgrrisfuqi
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 15, 2024 at 03:02:43PM -0400, Paul Moore wrote:
> On Mon, Apr 15, 2024 at 10:17=E2=80=AFAM Paul Moore <paul@paul-moore.com>=
 wrote:
> > On Mon, Apr 15, 2024 at 9:44=E2=80=AFAM Joel Granados <j.granados@samsu=
ng.com> wrote:
> > >
> > > Hey
> > >
> > > This is the only patch that I have not seen added to the next tree.
> > > I'll put this in the sysctl-next
> > > https://git.kernel.org/pub/scm/linux/kernel/git/sysctl/sysctl.git/log=
/?h=3Dsysctl-next
> > > for testing. Please let me know if It is lined up to be upstream thro=
ugh
> > > another path.
> >
> > I was hoping to see some ACKs from the associated LSM maintainers, but
> > it's minor enough I'll go ahead and pull it into the lsm/dev tree this
> > week.  I'll send a note later when I do the merge.
>=20
> ... and now it's merged, it should be in the next cut of the
> linux-next tree.  Thanks!

Awesome. I'll remove it from sysctl-next then to avoid any potential
crashes.

Thx

--=20

Joel Granados

--zfniyufgrrisfuqi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQGzBAABCgAdFiEErkcJVyXmMSXOyyeQupfNUreWQU8FAmYeLoAACgkQupfNUreW
QU+Ongv9G1IzPsRmO5Fp8LNQGL3RVW2HEJRFRdhkpCF3CIV4X8DYxzsnolosycOY
2BNak77S7o9TcL6MXnhQXS2tS8WNNdo1Yk9lpBb7Y1YlZhkjpXgaVj0lhoJiLskG
tuFbgn+QlMbWUmTPbHcX5Y0ZMp/zA28aWtUEY7b3UD1o7RzOvio6Im7IchVCl3Mw
xFsdxWtgzXO4dEsrwNg8RczshBE2lKLAiHAo5l8/EOw0bvdl8EtWP4wHnDlIWnkQ
p6Ms7mmp/iSOogETWZ9pxejUaZvcnX1mL2TBTAKnsqw9/JNA5vOjgdrP1O37DEs1
iUIVKlY8UqoUBYskAzCfwJFe5O5Unl4Y/hzWTTu0Vq75ZfkD9RN09R/ZUem1NxrZ
5rZ5yYTloIANF7PhUkTmYQKqoNInjtY1m3VUdw9rypOjJQ80cdwOOpYdE5xMS1O9
g+Ad9WDVhpCWhCsjONZ+GrRodtRsMlzOpQEd5HRqFWD8ciyCtWbcHgCBCffWLU0D
R6qovg//
=QO0O
-----END PGP SIGNATURE-----

--zfniyufgrrisfuqi--

