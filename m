Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E10643ACE5
	for <lists+io-uring@lfdr.de>; Tue, 26 Oct 2021 09:12:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231937AbhJZHOx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Oct 2021 03:14:53 -0400
Received: from out0.migadu.com ([94.23.1.103]:21506 "EHLO out0.migadu.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234671AbhJZHOi (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Tue, 26 Oct 2021 03:14:38 -0400
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cmpwn.com; s=key1;
        t=1635232322;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qowml88oFXgZx58We8Je8H/pdkfgblMYWcq5LhODy+o=;
        b=Jh2GKGYz2Is70r5KeVy6au/uf5joNWEud9yrn8w058+WSHqdphMKf6SJ0pkeiB8pzVfvL+
        4Wn8e8w9QQrcChzjw/6+sd/oTn3dWG1iuWFoB23ej/aHBr9oxbPjBJaCItE5jnvedHwGwT
        6I3ILensXQgcY2FyFCHTsCPDcXp3xkUIjsiORdRfsaAmexhyfreFpC0TyPszuCqFVMDMMD
        tgoQbrLNFVap49QmfcUY5gS8pzsxDyOh+Cb5gdsZ0e7GVi5os9A9e6+bYec6OcY48WH5CM
        lYequ1mWVuW0c+ufQ92Ic6uqxOmvCzSmXax2NGAn3yF3O4ijZglHkk6s6QGnig==
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date:   Tue, 26 Oct 2021 09:12:02 +0200
Message-Id: <CF95HABUTLQT.3S7V7X41CM2X2@taiga>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   "Drew DeVault" <sir@cmpwn.com>
To:     "Vito Caputo" <vcaputo@pengaru.com>
Cc:     <io-uring@vger.kernel.org>
Subject: Re: Is IORING_REGISTER_BUFFERS useful given the current default
 RLIMIT_MLOCK?
References: <CF8JHZUUYC1O.3DU8635RE8FSX@taiga>
 <20211025154247.fnw6ec75fmx5tkqy@shells.gnugeneration.com>
In-Reply-To: <20211025154247.fnw6ec75fmx5tkqy@shells.gnugeneration.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: sir@cmpwn.com
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon Oct 25, 2021 at 5:42 PM CEST, Vito Caputo wrote:
> If not for the gpg precedent cited, I'd say it's obviously
> distribution-specific defaults choice territory when it's as simple as
> what's preset in /etc/security/limits.conf.
>
> Systemd has also been getting its hands a bit dirty in the area of
> bumping resource limits, which I'm not sure how I feel about. But it
> does illustrate how downstream is perfectly capable of managing these
> limits on behalf of users.

Most distros don't touch this default value as far as I'm aware, and the
buck, as it were, stops with the kernel. I would prefer to bikeshed this
once rather than N times where N is the number of Linux distributions.

Accordingly, should any of the distros prefer the original value, or
another value, they're entirely able to configure new defaults according
to their preferences.
