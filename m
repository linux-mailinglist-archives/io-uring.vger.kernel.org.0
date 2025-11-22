Return-Path: <io-uring+bounces-10731-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A95E6C7C077
	for <lists+io-uring@lfdr.de>; Sat, 22 Nov 2025 01:50:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 65B163A5A5C
	for <lists+io-uring@lfdr.de>; Sat, 22 Nov 2025 00:50:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C7FC239E60;
	Sat, 22 Nov 2025 00:50:21 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 537D423ABAA;
	Sat, 22 Nov 2025 00:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=166.125.252.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763772621; cv=none; b=iRGnWT7cSQ+YpcJIUDfM6o+3YMWtv+leWcD3IIwzMgetziLzzrDcJWgo5hGOUUR8uj2ttPTy9TGqefN01VP7oNpQwPPlZc62u9TR+hg2rWYRD8YJs0aBzek3zBzDKuPwHXtvPtrUJdsK/a+GopYvIxBvg6vVC1Qhwy+xxCIFYg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763772621; c=relaxed/simple;
	bh=GMaYv5sMp4dLdH33xgWI2Beq5esJVRfV1HKZiAbEEGE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VweGE7FO0etHW2K9jMroSTxAiQx6yH3mQhe7eNbZbS+GljftAmeQEGabttFpd2p2oOHvYDLBb5OFnkSt0HPp6BeHLKW7xGwKCwbiabzXoKlbN5BLm5KHYyt4z12TobfitxcW+a0wPYxw8GzVFdg+OFdHuo7DA/IdcwtN9mQqOCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sk.com; spf=pass smtp.mailfrom=sk.com; arc=none smtp.client-ip=166.125.252.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sk.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sk.com
X-AuditID: a67dfc5b-c45ff70000001609-cf-692108c499c7
Date: Sat, 22 Nov 2025 09:50:07 +0900
From: Byungchul Park <byungchul@sk.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, kernel_team@skhynix.com, harry.yoo@oracle.com,
	hawk@kernel.org, andrew+netdev@lunn.ch, david@redhat.com,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	ziy@nvidia.com, willy@infradead.org, toke@redhat.com,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, horms@kernel.org, axboe@kernel.dk,
	ncardwell@google.com, kuniyu@google.com, dsahern@kernel.org,
	almasrymina@google.com, sdf@fomichev.me, dw@davidwei.uk,
	ap420073@gmail.com, dtatulea@nvidia.com, shivajikant@google.com,
	io-uring@vger.kernel.org
Subject: Re: [PATCH net-next 1/3] netmem, io_uring/zcrx: access pp fields
 through @desc in net_iov
Message-ID: <20251122005007.GA57205@system.software.com>
References: <20251121040047.71921-1-byungchul@sk.com>
 <72e3ecdf-343e-4d1b-9886-67d48372a06e@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <72e3ecdf-343e-4d1b-9886-67d48372a06e@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa0hTYRjHe885OzsuR6el+WagubBQySwUXsTUD0nHL6KI0QXSozvmaJsy
	L2kROUwtyWu3uUmtC94zWDKd2ChnllYmirpMbYkmXitN0QrLaZLffvyeP//n+fBQuGiOcKak
	ihROqWBlYlJACGbsHxxopdykPsZRd1SzlI4qrI08tFw7jqGyagNANUOFJCp7f4VAC09+4qiu
	KRtDxqZxgCbVj0k01jbCR5/KvxCoObcBRyOFr0k0m91JoC5DAQ91mqtI1JBp5aOepjISDdf+
	4aF2TRWBrg4+I1CbbidafDMNUG9pE4buD0ajbvMIgbSqAoB+La3mtS+H+cEuTH3VB4zpUxcT
	jMXUgTFGzRCf0elTmaeVnkzPu1RGX32NZPRzJXzG2DiPMflZsyTzfWyAYL6aeknmra6Vz8zr
	XcK3nRIESDiZNI1THgyMEST0//BIGsPSV/Ky8ExwE8sDdhSkfWF76QK5waYiFW5jgnaHA9Zx
	no1Jej+0WJbXvAPtBaf6W/h5QEDhdA4PWlV3QB6gqB20BFbm+9oyQhrBou76NS2iE2DHjP26
	3r66apSwMU57QsvKBGaL4PRuWLFC2bQdfQROfMsBNnak98Lnhlf/riym4OiY/zrvgi8qLUQR
	oDWbWjWbWjX/W3UArwYiqSJNzkplvt4JGQppundcolwPVj+h/NLv041griuyBdAUENsLw2P3
	SEU8Ni05Q94CIIWLHYSTfqtKKGEzLnDKxGhlqoxLbgG7KULsJDy8eF4ios+yKdw5jkvilBtT
	jLJzzgQi1yBevM/JuNQtaFYR4HXM7FKkjXPdF+EX1N7XXRcYHo9rrUOhrktOJ4pXFDDqeOj1
	9JDYqGjHGxcj9Kp4txL2bue90IdmtbzP4O9ZDWNUC7msTl617FWrClabkHdiWLMiLNLjY3D9
	memQo5+nKi5vfTSf0mnEb0fdmguTjYqJ5AT2kCeuTGb/Aq6Cpg0FAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA02Ra0hTYRyHe885OzsOFyeddVAonZhNTSsUXlAjieqloMQvQma69NCGOmWb
	5gJDMS0XXhHSuWIROHVascTLKBPnJbU0XeYSb1i2nKWmFVqiOSPy28Pzf36f/hTuMka4U1KZ
	kpXLxMlCkkfwzofmHu6kvKRHBi0CaFjNhPrpFg5cq7dhUFvXBKBhopiE2sGbBPzx+BcOH5ny
	MNhqsgFor2gg4Wz3DBdOVX8i4LNbzTicKX5JwoW8AQKa7/Vy4JumIg4cMNeSsDl7mgstJi0J
	J+s3ObBXU0vA2+PPCdit2wt/9n8BcKTShMEH43Fw2DxDwKqcIgB/r271VV2T3BMHUGPtewy9
	qyglkLWtD0Otmgku0hnT0dMaP2R5nY6MdQUkMi6XcVFrywqGCnMXSPRtdoxAi20jJHr4eQlD
	r3SdXLRi3B9JX+SFJbLJ0gxWHnQ8nicZ/S5Km8UyN9S5eDYox9TAiWLoYKatJAd3MEH7MGPT
	No6DSdqXsVrXtr2A9mfmRzu4asCjcDqfw0zn3AVqQFGudCJTUxjsaPg0ZEqGG7e1Cy1h+r46
	/9V7mN7Kj4SDcdqPsW7MYY4Epz0Y/Qbl0E50ODO3lA8c7EZ7M+1NPVgJ4Gt2rDU71pr/ax3A
	64BAKstIEUuTQwIVSRKVTJoZmJCaYgRbH6/OWi9tAd8tZzoATQGhMz/yiqfUhSPOUKhSOgBD
	4UIB3x6ypfiJYtV1Vp4aJ09PZhUdwIMihPv4Z6PZeBf6qljJJrFsGiv/d8UoJ/dskKIMCRis
	r2oUxQx7iwoaNpVP1odGC8qRImqXHdqn9KIL0SHnqIM+BklCRICrOab3UumNMi+3WHH6afOQ
	b2yBbbdB9GJNK2sKqqgNE7TfyQoKDY+YPGbUfzikOLlyqiaibHHeZ6RYNdBT5C+Lut//Vlfs
	eXl9SuoZuHxNvxDYJSQUEvFRP1yuEP8BF23cqO0CAAA=
X-CFilter-Loop: Reflected

On Fri, Nov 21, 2025 at 01:02:44PM +0000, Pavel Begunkov wrote:
> On 11/21/25 04:00, Byungchul Park wrote:
> > Convert all the legacy code directly accessing the pp fields in net_iov
> > to access them through @desc in net_iov.
> 
> Byungchul, that was already converted in the appropriate tree.

Nice!

	Byungchul
> 
> --
> Pavel Begunkov
> 

