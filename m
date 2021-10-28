Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BD4043E92B
	for <lists+io-uring@lfdr.de>; Thu, 28 Oct 2021 22:00:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230380AbhJ1UDK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 28 Oct 2021 16:03:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55962 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230323AbhJ1UDK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 28 Oct 2021 16:03:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635451242;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=CmJQmnSEmaBCvN4PFnFBseDnqy3HYRGaY5BGAEQG5ok=;
        b=QmSZlD88i59wTen657N8J9Li/QmUyCjSwx8yJTbO9mCM23gmVWnnvxouFpV3fsnN9qTOug
        HhUcN8o6tdOrD0DKk8DJGJTm4n8fFtkhr2Q28VAJ+AwKclcRBxslRxezRRe+bSgCoyhKU2
        GkKNRevUM5U+99DddxD8i4lOw9Nkyq0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-467-5isG3ltVOdiii_AWxcyN6Q-1; Thu, 28 Oct 2021 16:00:39 -0400
X-MC-Unique: 5isG3ltVOdiii_AWxcyN6Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DBBCBA40C0
        for <io-uring@vger.kernel.org>; Thu, 28 Oct 2021 20:00:38 +0000 (UTC)
Received: from madcap2.tricolour.com (unknown [10.3.128.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9102C26DFD;
        Thu, 28 Oct 2021 20:00:01 +0000 (UTC)
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Linux-Audit Mailing List <linux-audit@redhat.com>
Cc:     io-uring@vger.kernel.org, Steve Grubb <sgrubb@redhat.com>,
        Richard Guy Briggs <rgb@redhat.com>
Subject: [PATCH v3 0/7] Add uringop support
Date:   Thu, 28 Oct 2021 15:59:32 -0400
Message-Id: <20211028195939.3102767-1-rgb@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Audit support for iouring went into the upstream kernel with commit
5bd2182d58e9 ("audit,io_uring,io-wq: add some basic audit support to io_uring")
and commit 67daf270cebc ("audit: add filtering for io_uring records").

Add userspace support for AUDIT_URINGOP records, uringop fields and the
AUDIT_FILTER_URING_EXIT filter list.

Changelog:
v3
- rebase on openat2                                                                                                                                                                                                                 
- re-factor and re-order patchset

v2
- check for watch before adding perm
- update manpage to include filesystem filter
- add support for the AUDIT_URINGOP record type
- update support for the uring filter list: doc, -U op, op names
- add uringop support to ausearch
- add uringop support to aureport
- lots of bug fixes

Richard Guy Briggs (7):
  add basic support for the AUDIT_URINGOP record type
  add support for the uring filter list
  add support for uringop names
  add field support for the AUDIT_URINGOP record type
  add ausearch --uringop option
  add aureport --uringop option
  add iouring support to the normalizer

 audisp/plugins/ids/model_behavior.c |   1 +
 auparse/auparse-defs.h              |   2 +-
 auparse/auparse-idata.h             |   1 +
 auparse/ellist.c                    |   7 ++
 auparse/interpret.c                 |  21 ++++-
 auparse/normalize.c                 |   1 +
 auparse/normalize_record_map.h      |   1 +
 auparse/rnode.h                     |   1 +
 auparse/typetab.h                   |   1 +
 bindings/python/auparse_python.c    |   1 +
 contrib/plugin/audisp-example.c     |   1 +
 docs/audit.rules.7                  |  19 +++--
 docs/audit_add_rule_data.3          |   4 +
 docs/auditctl.8                     |  10 ++-
 docs/aureport.8                     |   3 +
 docs/ausearch.8                     |   3 +
 lib/Makefile.am                     |  17 +++-
 lib/flagtab.h                       |  11 +--
 lib/libaudit.c                      |  50 ++++++++---
 lib/libaudit.h                      |  11 +++
 lib/lookup_table.c                  |  21 +++++
 lib/msg_typetab.h                   |   1 +
 lib/private.h                       |   1 +
 lib/test/lookup_test.c              |  17 ++++
 lib/uringop_table.h                 |  62 ++++++++++++++
 src/auditctl-listing.c              |  52 ++++++++----
 src/auditctl.c                      | 121 +++++++++++++++++++++++----
 src/auditd-event.c                  |   1 +
 src/aureport-options.c              |  19 ++++-
 src/aureport-options.h              |   2 +-
 src/aureport-output.c               |  37 +++++++++
 src/aureport-scan.c                 |  26 ++++++
 src/aureport-scan.h                 |   2 +
 src/aureport.c                      |   3 +-
 src/ausearch-common.h               |   1 +
 src/ausearch-llist.c                |   2 +
 src/ausearch-llist.h                |   1 +
 src/ausearch-lookup.c               |  25 ++++++
 src/ausearch-lookup.h               |   1 +
 src/ausearch-match.c                |   6 +-
 src/ausearch-options.c              |  36 +++++++-
 src/ausearch-parse.c                | 123 +++++++++++++++++++++++++++-
 src/ausearch-report.c               |  21 ++++-
 43 files changed, 677 insertions(+), 70 deletions(-)
 create mode 100644 lib/uringop_table.h

-- 
2.27.0

