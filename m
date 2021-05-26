Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FE76391AF2
	for <lists+io-uring@lfdr.de>; Wed, 26 May 2021 16:59:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235160AbhEZPA6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 26 May 2021 11:00:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27529 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233472AbhEZPA5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 26 May 2021 11:00:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622041166;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=g8CijyfwO5N381a5vO9gsDiJcxVrmiwd12Zozn8q0sA=;
        b=PmAiF1nwFTp6ZhatGSfuaV6gK8MqCHrtMsBaz07OlOQNwCk5ubnuc9j06M18LF3odnETWs
        +09Q812EhmqCmSkU8jp3TNM5cz03pL0eecUj8UrZyspMNvyQh/n/lzV+6rxPsAhE3E/KLm
        MjDGWimy9j5EnV3SFCct8c2MrGb0B/8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-433-10iZz8AqPL27JoYZSTHWTQ-1; Wed, 26 May 2021 10:59:21 -0400
X-MC-Unique: 10iZz8AqPL27JoYZSTHWTQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A650210CE781;
        Wed, 26 May 2021 14:59:19 +0000 (UTC)
Received: from segfault.boston.devel.redhat.com (segfault.boston.devel.redhat.com [10.19.60.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 441105D6D3;
        Wed, 26 May 2021 14:59:15 +0000 (UTC)
From:   Jeff Moyer <jmoyer@redhat.com>
To:     Paul Moore <paul@paul-moore.com>
Cc:     linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        linux-audit@redhat.com, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [RFC PATCH 0/9] Add LSM access controls and auditing to io_uring
References: <162163367115.8379.8459012634106035341.stgit@sifl>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
Date:   Wed, 26 May 2021 11:00:09 -0400
In-Reply-To: <162163367115.8379.8459012634106035341.stgit@sifl> (Paul Moore's
        message of "Fri, 21 May 2021 17:49:41 -0400")
Message-ID: <x498s41o806.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Paul Moore <paul@paul-moore.com> writes:

> Also, any pointers to easy-to-run io_uring tests would be helpful.  I
> am particularly interested in tests which make use of the personality
> option, share urings across process boundaries, and make use of the
> sqpoll functionality.

liburing contains a test suite:
  https://git.kernel.dk/cgit/liburing/

You can run it via 'make runtests'.

Cheers,
Jeff

