Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2ED5F5829B2
	for <lists+io-uring@lfdr.de>; Wed, 27 Jul 2022 17:34:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232685AbiG0PeW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 27 Jul 2022 11:34:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232127AbiG0PeW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 27 Jul 2022 11:34:22 -0400
X-Greylist: delayed 401 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 27 Jul 2022 08:34:19 PDT
Received: from euporie.uberspace.de (euporie.uberspace.de [185.26.156.232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5809E237D9
        for <io-uring@vger.kernel.org>; Wed, 27 Jul 2022 08:34:19 -0700 (PDT)
Received: (qmail 14935 invoked by uid 989); 27 Jul 2022 15:27:36 -0000
Authentication-Results: euporie.uberspace.de;
        auth=pass (plain)
From:   Florian Fischer <florian.fischer@muhq.space>
To:     io-uring@vger.kernel.org
Cc:     Florian Schmaus <flow@cs.fau.de>,
        Florian Fischer <florian.fischer@muhq.space>
Subject: [PATCH liburing] add additional meson build system support
Date:   Wed, 27 Jul 2022 17:27:14 +0200
Message-Id: <20220727152723.3320169-1-florian.fischer@muhq.space>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Bar: /
X-Rspamd-Report: MIME_GOOD(-0.1) MID_CONTAINS_FROM(1) BAYES_HAM(-0.71453)
X-Rspamd-Score: 0.185469
Received: from unknown (HELO unkown) (::1)
        by euporie.uberspace.de (Haraka/2.8.28) with ESMTPSA; Wed, 27 Jul 2022 17:27:36 +0200
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,
        MSGID_FROM_MTA_HEADER,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This patch series add an additional build system to liburing based
on the initial meson code proposed by Peter Eszlari <peter.eszlari@gmail.com>.
Since the initial proposal [1] in Februar 2021 I took up the meson code and
improved, maintained and made it available in the meson wrapdb [2].

Meson is a modern, fast and simple build system. Adoption started mainly in the
desktop space (Gnome, X11, Mesa) to replace autotools, but since then,
some low level projects (systemd, qemu) have switched to it too.

Using meson as build system has multiple advantages over the current custom
configure plus Makefile implementation:

* Out-of-source builds
* Seamlessly consumable by other projects using meson
* Meson generates the compile_commands.json database used i.e., by clangd
* Packagers can use a standardized and well known build system

 .github/workflows/build.yml      |  45 ++++++++-
 .gitignore                       |   2 +
 examples/meson.build             |  19 ++++
 man/meson.build                  | 116 ++++++++++++++++++++++
 meson.build                      | 119 ++++++++++++++++++++++
 meson_options.txt                |  14 +++
 src/include/liburing/compat.h.in |   7 ++
 src/include/liburing/meson.build |  51 ++++++++++
 src/include/meson.build          |   3 +
 src/meson.build                  |  28 ++++++
 test/meson.build                 | 219 +++++++++++++++++++++++++++++++++++++++++
 11 files changed, 619 insertions(+), 4 deletions(-)

The patch set requires at least meson version 0.53 satisfied by most distributions.

It has a working github bot integration equivalent to the current build system.

Myself and multiple other github users (Yury Zhuravlev @stalkberg, Tim-Philipp
Müller @tp-m) [3] proposed to maintain the meson code once included.
For support regarding the meson code I am available via email or the mailing list.

[1]: https://github.com/axboe/liburing/pull/297
[2]: https://github.com/mesonbuild/wrapdb/commit/b800267fa9b1e05b03faf968c6ce6a882b6a2494
[3]: https://github.com/axboe/liburing/pull/622

Link: https://github.com/axboe/liburing/pull/622
Signed-off-by: Florian Fischer <florian.fischer@muhq.space>
---

This patch series cleanly applies to the current liburing master (1842b2a)
and includes all tests, examples and manpages available up to 1842b2a.


