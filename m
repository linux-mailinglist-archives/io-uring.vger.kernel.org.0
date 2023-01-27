Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57FD567EC59
	for <lists+io-uring@lfdr.de>; Fri, 27 Jan 2023 18:25:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235182AbjA0RZE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 27 Jan 2023 12:25:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234116AbjA0RZD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 27 Jan 2023 12:25:03 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6088D78AE4
        for <io-uring@vger.kernel.org>; Fri, 27 Jan 2023 09:24:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674840255;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=byDEmUGEGgpYWTCn0j5MJVl39Av7Yzv/REfP3hehrGg=;
        b=VdKCtyPHzX+3A0nAH+uUd8+n/AKaUH3HmggqTysTIgtN9QDsJTF/9tdTTid4FWzQ0M6Zxc
        pcJvd1HETOgfrw8FZY48qTlh39tAswvvQqm/TnPrlwVYZhX07e7HDdPHtiV5FbKwi0jXIz
        +IGUZtgPnCjo4ghoFKIyil4cnAIlqxs=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-538-i1woC35QPImrScpYd5jmew-1; Fri, 27 Jan 2023 12:24:12 -0500
X-MC-Unique: i1woC35QPImrScpYd5jmew-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6F806385F36B;
        Fri, 27 Jan 2023 17:24:11 +0000 (UTC)
Received: from madcap2.tricolour.com (ovpn-0-3.rdu2.redhat.com [10.22.0.3])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F33672166B26;
        Fri, 27 Jan 2023 17:24:09 +0000 (UTC)
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, io-uring@vger.kernel.org
Cc:     Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@parisplace.org>,
        Steve Grubb <sgrubb@redhat.com>,
        Richard Guy Briggs <rgb@redhat.com>,
        Stefan Roesch <shr@fb.com>,
        Christian Brauner <brauner@kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH v1 0/2] two suggested iouring op audit updates
Date:   Fri, 27 Jan 2023 12:23:44 -0500
Message-Id: <cover.1674682056.git.rgb@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

A couple of updates to the iouring ops audit bypass selections suggested in
consultation with Steve Grubb.

Richard Guy Briggs (2):
  io_uring,audit: audit IORING_OP_FADVISE but not IORING_OP_MADVISE
  io_uring,audit: do not log IORING_OP_*GETXATTR

 io_uring/opdef.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

-- 
2.27.0

