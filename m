Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2702145521A
	for <lists+io-uring@lfdr.de>; Thu, 18 Nov 2021 02:20:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242235AbhKRBX2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 17 Nov 2021 20:23:28 -0500
Received: from dcvr.yhbt.net ([64.71.152.64]:36178 "EHLO dcvr.yhbt.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242201AbhKRBXT (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Wed, 17 Nov 2021 20:23:19 -0500
Received: from localhost (dcvr.yhbt.net [127.0.0.1])
        by dcvr.yhbt.net (Postfix) with ESMTP id A79271F9F4;
        Thu, 18 Nov 2021 01:20:19 +0000 (UTC)
Date:   Thu, 18 Nov 2021 01:20:19 +0000
From:   Eric Wong <e@80x24.org>
To:     Stefan Metzmacher <metze@samba.org>
Cc:     io-uring@vger.kernel.org,
        Liu Changcheng <changcheng.liu@aliyun.com>
Subject: Re: [PATCH 3/4] debian/rules: fix for newer debhelper
Message-ID: <20211118012019.M599810@dcvr>
References: <20211116224456.244746-1-e@80x24.org>
 <20211116224456.244746-4-e@80x24.org>
 <fadf956d-bbbc-0b3a-653d-9e0e979cce80@samba.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <fadf956d-bbbc-0b3a-653d-9e0e979cce80@samba.org>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Stefan Metzmacher <metze@samba.org> wrote:
> > +# --add-udeb is needed for <= 12.3, and breaks with auto-detection
> > +#  on debhelper 13.3.4, at least
> > +	if perl -MDebian::Debhelper::Dh_Version -e \
> > +	'exit(eval("v$$Debian::Debhelper::Dh_Version::version") le v12.3)'; \
> > +		then dh_makeshlibs -a; else \
> > +		dh_makeshlibs -a --add-udeb '$(libudeb)'; fi
> > +
> 
> I think this needs to be 'ge v12.3)' instead of 'le v12.3)'
> otherwise I still get the above error on ubuntu 20.04.

It should be 'lt v12.3', actually.  The Perl exit() with
a falsy value means it's `true' for the `if' shell statement.
Yes, I got confused, too :x  Will fix.
