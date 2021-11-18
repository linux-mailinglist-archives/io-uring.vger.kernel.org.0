Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6686A45532B
	for <lists+io-uring@lfdr.de>; Thu, 18 Nov 2021 04:11:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242687AbhKRDN6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 17 Nov 2021 22:13:58 -0500
Received: from dcvr.yhbt.net ([64.71.152.64]:41378 "EHLO dcvr.yhbt.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242676AbhKRDN5 (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Wed, 17 Nov 2021 22:13:57 -0500
Received: from localhost (dcvr.yhbt.net [127.0.0.1])
        by dcvr.yhbt.net (Postfix) with ESMTP id 3AB891FA1A;
        Thu, 18 Nov 2021 03:10:17 +0000 (UTC)
From:   Eric Wong <e@80x24.org>
To:     io-uring@vger.kernel.org
Cc:     Liu Changcheng <changcheng.liu@aliyun.com>,
        Stefan Metzmacher <metze@samba.org>
Subject: [PATCH v2 7/7] make-debs: remove dependency on git
Date:   Thu, 18 Nov 2021 03:10:16 +0000
Message-Id: <20211118031016.354105-8-e@80x24.org>
In-Reply-To: <20211118031016.354105-1-e@80x24.org>
References: <20211118031016.354105-1-e@80x24.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This allows building Debian packages from future release
tarballs which lack a .git directory.  Also, fix a spelling
error while we're at it.

Signed-off-by: Eric Wong <e@80x24.org>
---
 make-debs.sh | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/make-debs.sh b/make-debs.sh
index 0913c47..867612b 100755
--- a/make-debs.sh
+++ b/make-debs.sh
@@ -39,7 +39,12 @@ orgfile=$(echo $outfile | tr '-' '_')
 # Prepare source code
 cp -arf ${dirname}/${basename} ${releasedir}/${outfile}
 cd ${releasedir}/${outfile}
-git clean -dxf
+if git clean -dxf
+then
+	rm -rf .git
+else # building from unpacked tarball
+	make clean
+fi
 
 # Change changelog if it's needed
 cur_ver=$(sed -n -e '1s/.* (\(.*\)) .*/\1/p' debian/changelog)
@@ -47,7 +52,7 @@ if [ "$cur_ver" != "$version-1" ]; then
 	dch -D $codename --force-distribution -b -v "$version-1" "new version"
 fi
 
-# Create tar archieve
+# Create tar archive
 cd ../
 tar cvzf ${outfile}.tar.gz ${outfile}
 ln -s ${outfile}.tar.gz ${orgfile}.orig.tar.gz
