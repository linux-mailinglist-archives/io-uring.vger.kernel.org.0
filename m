Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86C4643487B
	for <lists+io-uring@lfdr.de>; Wed, 20 Oct 2021 12:02:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbhJTKEi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 20 Oct 2021 06:04:38 -0400
Received: from out2.migadu.com ([188.165.223.204]:17688 "EHLO out2.migadu.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229555AbhJTKEh (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Wed, 20 Oct 2021 06:04:37 -0400
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cmpwn.com; s=key1;
        t=1634724142;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4/wjJQZry37bbMmpxercCId5eODjkwsGYTt73DOKz6s=;
        b=tOR8AYR6m+Snbeul56xCnYEGCAlLUgbAf2Wc8vefoqd0/YfIldNOtrPTuRCTwIgTDLyjGm
        AWtGYG674+2hrn6gsrkmAjw+8BHr+CuPdh268/Yd1Eq6xJSi9u+/mRj5r2BVfct2mAWiOv
        /uu5YW+KD4Lwe4dWHwICB1i/clWYnuHyptp8t5X7zC2PADVQH0cRn+fVroUOKHP71zI2bk
        r8ubPMSUn+I6iAOIWVMWm8PKvQRvhtl/g063kIzgjq3D2cbS+ez4nlXGdd5TIloftOi9DZ
        yxr38A6ehqG4vMux5PGl0tJwA8OagYFpd0q9ymHiT9CRJEe9oI7OtCrnA/ipIQ==
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date:   Wed, 20 Oct 2021 12:02:22 +0200
Message-Id: <CF45CFOIEIKW.91QTI618WTPH@taiga>
Subject: Re: Polling on an io_uring file descriptor
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   "Drew DeVault" <sir@cmpwn.com>
To:     "Drew DeVault" <sir@cmpwn.com>, <io-uring@vger.kernel.org>
References: <CF44HAZOCG3O.1IGR35UF76JWC@taiga>
In-Reply-To: <CF44HAZOCG3O.1IGR35UF76JWC@taiga>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: sir@cmpwn.com
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

I found IOURING_REGISTER_EVENTFD, which does what I need. Pardon the
noise.
