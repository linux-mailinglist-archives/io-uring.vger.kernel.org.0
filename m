Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 300C158344C
	for <lists+io-uring@lfdr.de>; Wed, 27 Jul 2022 22:53:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233571AbiG0Ux5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 27 Jul 2022 16:53:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229924AbiG0Ux4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 27 Jul 2022 16:53:56 -0400
Received: from euporie.uberspace.de (euporie.uberspace.de [185.26.156.232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B7AC5072E
        for <io-uring@vger.kernel.org>; Wed, 27 Jul 2022 13:53:52 -0700 (PDT)
Received: (qmail 7572 invoked by uid 989); 27 Jul 2022 20:53:50 -0000
Authentication-Results: euporie.uberspace.de;
        auth=pass (plain)
Date:   Wed, 27 Jul 2022 22:53:29 +0200
From:   Florian Fischer <florian.fischer@muhq.space>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     io-uring@vger.kernel.org, Florian Schmaus <flow@cs.fau.de>
Subject: Re: [PATCH liburing] add additional meson build system support
Message-ID: <20220727205329.jgr5i5ou4oxc2ttc@pasture>
Mail-Followup-To: Bart Van Assche <bvanassche@acm.org>,
        io-uring@vger.kernel.org, Florian Schmaus <flow@cs.fau.de>
References: <20220727152723.3320169-1-florian.fischer@muhq.space>
 <678c7d14-22da-1522-ea41-5dbd21e0c7b4@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <678c7d14-22da-1522-ea41-5dbd21e0c7b4@acm.org>
X-Rspamd-Bar: --
X-Rspamd-Report: MIME_GOOD(-0.1) MID_RHS_NOT_FQDN(0.5) BAYES_HAM(-2.704215)
X-Rspamd-Score: -2.304215
Received: from unknown (HELO unkown) (::1)
        by euporie.uberspace.de (Haraka/2.8.28) with ESMTPSA; Wed, 27 Jul 2022 22:53:50 +0200
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,
        MSGID_FROM_MTA_HEADER,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 27.07.2022 12:21, Bart Van Assche wrote:
> On 7/27/22 08:27, Florian Fischer wrote:
> >   11 files changed, 619 insertions(+), 4 deletions(-)
> 
> To me this diffstat tells me that this patch series adds a lot of complexity
> instead of removing complexity.

That's because Jens wants to keep both build systems in the repository.

 .github/workflows/build.yml      |  44 +++++--
 .gitignore                       |   2 +
 Makefile                         |  84 ------------
 Makefile.common                  |   6 -
 Makefile.quiet                   |  11 --
 configure                        | 467 -----------------------------------------------------------------
 examples/Makefile                |  41 ------
 examples/meson.build             |  19 +++
 man/meson.build                  | 116 ++++++++++++++++
 meson.build                      | 119 +++++++++++++++++
 meson_options.txt                |  14 ++
 src/Makefile                     |  87 ------------
 src/include/liburing/compat.h.in |   7 +
 src/include/liburing/meson.build |  51 +++++++
 src/include/meson.build          |   3 +
 src/meson.build                  |  28 ++++
 test/Makefile                    | 238 ---------------------------------
 test/meson.build                 | 219 +++++++++++++++++++++++++++++++
 18 files changed, 609 insertions(+), 947 deletions(-)

This is what the diffstat could look like if we would remove the old build system.


> That leaves me wondering what the advantages of this patch series are?

The most notable advantages of having a meson-based build system are highlighted
in the cover mail.

For me the by far most important feature and why I maintained the initial meson
code from 2021 is the interoperability with other meson-based projects.

Everything needed to consume liburing is to have a wrap file for liburing in your
subprojects directory and use it in your meson build logic.

subprojects/liburing.wrap:

  [wrap-git]
  url = https://git.kernel.dk/liburing
  revision = master

And use the following lines in your meson code:

  liburing_proj = subproject('emper')
  liburing_dep = liburing_proj/get_variable('uring')
  # somehow use the dependency object

---
Florian Fischer
