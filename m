Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41B544964F9
	for <lists+io-uring@lfdr.de>; Fri, 21 Jan 2022 19:26:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382087AbiAUS0f (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Jan 2022 13:26:35 -0500
Received: from dcvr.yhbt.net ([64.71.152.64]:50752 "EHLO dcvr.yhbt.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1381902AbiAUS0f (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Fri, 21 Jan 2022 13:26:35 -0500
Received: from localhost (dcvr.yhbt.net [127.0.0.1])
        by dcvr.yhbt.net (Postfix) with ESMTP id 2DF6C1F852;
        Fri, 21 Jan 2022 18:26:35 +0000 (UTC)
From:   Eric Wong <e@80x24.org>
To:     io-uring@vger.kernel.org
Cc:     Stefan Metzmacher <metze@samba.org>,
        Liu Changcheng <changcheng.liu@aliyun.com>,
        Eric Wong <e@80x24.org>
Subject: [PULL|PATCH v3 0/7] liburing debian packaging fixes
Date:   Fri, 21 Jan 2022 18:26:28 +0000
Message-Id: <20220121182635.1147333-1-e@80x24.org>
In-Reply-To: <20211116224456.244746-1-e@80x24.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The previous patch 8/7 in v2 is squashed into 3/7 in this series.
Apologies for the delay since v2, many bad things happened :<

The following changes since commit bbcaabf808b53ef11ad9851c6b968140fb430500:

  man/io_uring_enter.2: make it clear that chains terminate at submit (2022-01-19 18:09:40 -0700)

are available in the Git repository at:

  https://yhbt.net/liburing.git deb-v3

for you to fetch changes up to 77b99bb1dbe237eef38eceb313501a9fd247d672:

  make-debs: remove dependency on git (2022-01-21 16:54:42 +0000)

----------------------------------------------------------------
Eric Wong (7):
      make-debs: fix version detection
      debian: avoid prompting package builder for signature
      debian/rules: fix for newer debhelper
      debian/rules: support parallel build
      debian: rename package to liburing2 to match .so version
      make-debs: use version from RPM .spec
      make-debs: remove dependency on git

 Makefile                                           |  5 ++++-
 debian/changelog                                   |  6 ++++++
 debian/control                                     |  6 +++---
 ...buring1-udeb.install => liburing2-udeb.install} |  0
 debian/{liburing1.install => liburing2.install}    |  0
 debian/{liburing1.symbols => liburing2.symbols}    |  2 +-
 debian/rules                                       | 22 ++++++++++++++++++++--
 make-debs.sh                                       | 19 ++++++++++++++-----
 8 files changed, 48 insertions(+), 12 deletions(-)
 rename debian/{liburing1-udeb.install => liburing2-udeb.install} (100%)
 rename debian/{liburing1.install => liburing2.install} (100%)
 rename debian/{liburing1.symbols => liburing2.symbols} (97%)
