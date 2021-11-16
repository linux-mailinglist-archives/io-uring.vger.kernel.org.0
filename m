Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6B2B453C66
	for <lists+io-uring@lfdr.de>; Tue, 16 Nov 2021 23:53:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230487AbhKPW4b (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 16 Nov 2021 17:56:31 -0500
Received: from dcvr.yhbt.net ([64.71.152.64]:43734 "EHLO dcvr.yhbt.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229527AbhKPW4b (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Tue, 16 Nov 2021 17:56:31 -0500
Received: from localhost (dcvr.yhbt.net [127.0.0.1])
        by dcvr.yhbt.net (Postfix) with ESMTP id 698ED1F953;
        Tue, 16 Nov 2021 22:44:56 +0000 (UTC)
From:   Eric Wong <e@80x24.org>
To:     io-uring@vger.kernel.org
Cc:     Liu Changcheng <changcheng.liu@aliyun.com>,
        Stefan Metzmacher <metze@samba.org>
Subject: [PATCH 0/4] liburing debian packaging fixes.
Date:   Tue, 16 Nov 2021 22:44:52 +0000
Message-Id: <20211116224456.244746-1-e@80x24.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

I'm testing liburing on my Debian 11.x (bullseye) system and ran
into some problems with the current packaging.  The official
Debian packages are only on liburing-0.7, so I'm building from
git.

Here are some fixes and speedups, tested on both Debian 11.x and
10.x (buster).

Eric Wong (4):
  make-debs: fix version detection
  debian: avoid prompting package builder for signature
  debian/rules: fix for newer debhelper
  debian/rules: support parallel build

 debian/changelog |  6 ++++++
 debian/rules     | 19 ++++++++++++++++++-
 make-debs.sh     |  8 ++++++--
 3 files changed, 30 insertions(+), 3 deletions(-)
