Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DFBD4964FA
	for <lists+io-uring@lfdr.de>; Fri, 21 Jan 2022 19:26:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381902AbiAUS0h (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Jan 2022 13:26:37 -0500
Received: from dcvr.yhbt.net ([64.71.152.64]:50854 "EHLO dcvr.yhbt.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235596AbiAUS0h (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Fri, 21 Jan 2022 13:26:37 -0500
Received: from localhost (dcvr.yhbt.net [127.0.0.1])
        by dcvr.yhbt.net (Postfix) with ESMTP id 5B1371F9FC;
        Fri, 21 Jan 2022 18:26:35 +0000 (UTC)
From:   Eric Wong <e@80x24.org>
To:     io-uring@vger.kernel.org
Cc:     Stefan Metzmacher <metze@samba.org>,
        Liu Changcheng <changcheng.liu@aliyun.com>,
        Eric Wong <e@80x24.org>
Subject: [PATCH v3 1/7] make-debs: fix version detection
Date:   Fri, 21 Jan 2022 18:26:29 +0000
Message-Id: <20220121182635.1147333-2-e@80x24.org>
In-Reply-To: <20220121182635.1147333-1-e@80x24.org>
References: <20220121182635.1147333-1-e@80x24.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

`head -l' is not supported on my version of head(1) on Debian
buster nor bullseye (and AFAIK, not any version of head(1)).
Furthermore, head(1) is not required at all since sed(1) can
limit operations to any line.

Since this is a bash script, we'll also use "set -o pipefail" to
ensure future errors of this type are caught.

Signed-off-by: Eric Wong <e@80x24.org>
---
 make-debs.sh | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/make-debs.sh b/make-debs.sh
index 01d563c..136b79e 100755
--- a/make-debs.sh
+++ b/make-debs.sh
@@ -16,6 +16,7 @@
 # along with this program.  If not, see <http://www.gnu.org/licenses/>.
 #
 set -xe
+set -o pipefail
 
 # Create dir for build
 base=${1:-/tmp/release}
@@ -38,7 +39,7 @@ cd ${releasedir}/${outfile}
 git clean -dxf
 
 # Change changelog if it's needed
-cur_ver=`head -l debian/changelog | sed -n -e 's/.* (\(.*\)) .*/\1/p'`
+cur_ver=$(sed -n -e '1s/.* (\(.*\)) .*/\1/p' debian/changelog)
 if [ "$cur_ver" != "$version-1" ]; then
 	dch -D $codename --force-distribution -b -v "$version-1" "new version"
 fi
