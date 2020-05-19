Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 260D51DA4EC
	for <lists+io-uring@lfdr.de>; Wed, 20 May 2020 00:46:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726447AbgESWqd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 19 May 2020 18:46:33 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:41620 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726064AbgESWqd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 19 May 2020 18:46:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589928392;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=02dJ0uXJ0xn83i4+L698PBVA99CfwjQdZKndCX98MFs=;
        b=F4ffH+DkGkRkHOPsSfT/t+aufb/Q1Hco3SJpW5flT5YejylsDkIGID+M4DXlMFKB/dswSS
        a4oiOm7+T08lAiRlAxFHVdoFJt7NNtzC98hBckD6oMnfO1YyQLvC2LiYg+XAJRgjeubmuu
        afIi7eRyc0gwdsTX1NoESTS6cM0t8mU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-23-VXpKR9asM_GgPnCpdOeGFw-1; Tue, 19 May 2020 18:46:28 -0400
X-MC-Unique: VXpKR9asM_GgPnCpdOeGFw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6BE23835B41;
        Tue, 19 May 2020 22:46:27 +0000 (UTC)
Received: from segfault.boston.devel.redhat.com (segfault.boston.devel.redhat.com [10.19.60.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 274115C1BB;
        Tue, 19 May 2020 22:46:27 +0000 (UTC)
From:   Jeff Moyer <jmoyer@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Subject: Re: liburing 500f9fbadef8-test test failure on top-of-tree
References: <x49d06zd1u2.fsf@segfault.boston.devel.redhat.com>
        <45c638c9-1ff1-efe8-7698-fb53fceb15a7@kernel.dk>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
Date:   Tue, 19 May 2020 18:46:26 -0400
In-Reply-To: <45c638c9-1ff1-efe8-7698-fb53fceb15a7@kernel.dk> (Jens Axboe's
        message of "Tue, 19 May 2020 16:08:49 -0600")
Message-ID: <x491rnfczlp.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Jens Axboe <axboe@kernel.dk> writes:

>> Jens, what do you think?
>
> See: https://lore.kernel.org/io-uring/1589925170-48687-1-git-send-email-bijan.mottahedeh@oracle.com/T/#m9cec13d26c0b2db03889e1b36c9bcc20f4f8244a

Hmm, I wonder why that hasn't landed in my inbox yet.  Oh well, glad
it's resolved.  I think I also hit the issue fixed by patch2.  I'll test
that as well.

Thanks!
Jeff

