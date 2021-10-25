Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBC7A439AC3
	for <lists+io-uring@lfdr.de>; Mon, 25 Oct 2021 17:48:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233008AbhJYPuq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 Oct 2021 11:50:46 -0400
Received: from shells.gnugeneration.com ([66.240.222.126]:39794 "EHLO
        shells.gnugeneration.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232776AbhJYPuq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Oct 2021 11:50:46 -0400
X-Greylist: delayed 335 seconds by postgrey-1.27 at vger.kernel.org; Mon, 25 Oct 2021 11:50:46 EDT
Received: by shells.gnugeneration.com (Postfix, from userid 1000)
        id EC5A11A401FF; Mon, 25 Oct 2021 08:42:47 -0700 (PDT)
Date:   Mon, 25 Oct 2021 08:42:47 -0700
From:   Vito Caputo <vcaputo@pengaru.com>
To:     Drew DeVault <sir@cmpwn.com>
Cc:     io-uring@vger.kernel.org
Subject: Re: Is IORING_REGISTER_BUFFERS useful given the current default
 RLIMIT_MLOCK?
Message-ID: <20211025154247.fnw6ec75fmx5tkqy@shells.gnugeneration.com>
References: <CF8JHZUUYC1O.3DU8635RE8FSX@taiga>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CF8JHZUUYC1O.3DU8635RE8FSX@taiga>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Oct 25, 2021 at 03:58:33PM +0200, Drew DeVault wrote:
> The current default for RLIMIT_MLOCK is set to 64 KiB. This is not much!
> This limit was set to this value in 2008 at the request of GnuPG.
> 
> I understand that the main audience of io_uring is high-performance
> servers and such, where configuring the rlimits appropriately is not a
> particularly burdensome ask. However, this dramatically limits the
> utility of IORING_REGISTER_BUFFERS in the end-user software use-case,
> almost such that it's entirely pointless *without* raising the mlock
> rlimit.
> 
> I wonder if we can/should make a case for raising the default rlimit to
> something more useful for $CURRENTYEAR?

If not for the gpg precedent cited, I'd say it's obviously
distribution-specific defaults choice territory when it's as simple as
what's preset in /etc/security/limits.conf.

Systemd has also been getting its hands a bit dirty in the area of
bumping resource limits, which I'm not sure how I feel about.  But it
does illustrate how downstream is perfectly capable of managing these
limits on behalf of users.

Regards,
Vito Caputo
