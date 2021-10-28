Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 980AF43E936
	for <lists+io-uring@lfdr.de>; Thu, 28 Oct 2021 22:01:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230526AbhJ1UDv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 28 Oct 2021 16:03:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55237 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231124AbhJ1UDu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 28 Oct 2021 16:03:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635451282;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CFJojDEGFuKRw/Qck8GWeomRgFyKKiULAQK8t7p7j7U=;
        b=UZLLNp6m9WeR+ldk15IigYwJOID4KW0ZWq6rjV+6iEN6ldwCpH6o6TxN6MWHm++QwuHpET
        al3gb2wHICCigubc8ku61M6LnUdmuZupH0JIcWlZLsz31QT116YiQDaBk8r+7knK3W+ql+
        S0EH6PGyTo4ay7OXEUJmxOOQzzUpNDs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-301-0iArfME3OK62BsWmjESELw-1; Thu, 28 Oct 2021 16:01:21 -0400
X-MC-Unique: 0iArfME3OK62BsWmjESELw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 56BA384BA62
        for <io-uring@vger.kernel.org>; Thu, 28 Oct 2021 20:01:20 +0000 (UTC)
Received: from madcap2.tricolour.com (unknown [10.3.128.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 58A6F26379;
        Thu, 28 Oct 2021 20:01:19 +0000 (UTC)
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Linux-Audit Mailing List <linux-audit@redhat.com>
Cc:     io-uring@vger.kernel.org, Steve Grubb <sgrubb@redhat.com>,
        Richard Guy Briggs <rgb@redhat.com>
Subject: [PATCH v3 7/7] add iouring support to the normalizer
Date:   Thu, 28 Oct 2021 15:59:39 -0400
Message-Id: <20211028195939.3102767-8-rgb@redhat.com>
In-Reply-To: <20211028195939.3102767-1-rgb@redhat.com>
References: <20211028195939.3102767-1-rgb@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 auparse/normalize.c            | 1 +
 auparse/normalize_record_map.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/auparse/normalize.c b/auparse/normalize.c
index 0ccabc5e397e..55943263f4a4 100644
--- a/auparse/normalize.c
+++ b/auparse/normalize.c
@@ -1037,6 +1037,7 @@ static const char *normalize_determine_evkind(int type)
 		case AUDIT_SOCKADDR ... AUDIT_MQ_GETSETATTR:
 		case AUDIT_FD_PAIR ... AUDIT_OBJ_PID:
 		case AUDIT_BPRM_FCAPS ... AUDIT_NETFILTER_PKT:
+		case AUDIT_URINGOP:
 			kind = NORM_EVTYPE_AUDIT_RULE;
 			break;
 		case AUDIT_FANOTIFY:
diff --git a/auparse/normalize_record_map.h b/auparse/normalize_record_map.h
index 395eac05e0e3..75f555f2b612 100644
--- a/auparse/normalize_record_map.h
+++ b/auparse/normalize_record_map.h
@@ -87,6 +87,7 @@ _S(AUDIT_FANOTIFY, "accessed-policy-controlled-file")
 //_S(AUDIT_BPF, "")
 //_S(AUDIT_EVENT_LISTENER, "")
 //_S(AUDIT_OPENAT2, "")
+_S(AUDIT_URINGOP, "io_uring-operation")
 _S(AUDIT_AVC, "accessed-mac-policy-controlled-object")
 _S(AUDIT_MAC_POLICY_LOAD, "loaded-selinux-policy")
 _S(AUDIT_MAC_STATUS, "changed-selinux-enforcement-to")
-- 
2.27.0

