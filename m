Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A430792A4D
	for <lists+io-uring@lfdr.de>; Tue,  5 Sep 2023 18:59:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244808AbjIEQer (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 5 Sep 2023 12:34:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354537AbjIEMZC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 5 Sep 2023 08:25:02 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 650911A8;
        Tue,  5 Sep 2023 05:24:59 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 25A0E219F8;
        Tue,  5 Sep 2023 12:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1693916698; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=y+TAx88oFB04zxtoLdsW/MXynwxPjQoRFvKwN54GWMg=;
        b=LRYOH3LSFhDzKKM4DUzc+kdHqXIyM/vtRKortnk8B8zJmC1aexzJ2+eT6gRElpNRDZNfst
        DyGtFNvQr6R6tVo1/IaVw9bdB30839uFy0RejToseG/6up6DpaDQqny7cP3ZDsRanvxi0t
        VZWI53CYa/vTrJx6zjiIFewzzYnYSo0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1693916698;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=y+TAx88oFB04zxtoLdsW/MXynwxPjQoRFvKwN54GWMg=;
        b=XhEKCOXH9DQMmv1df2jH6uZaO4bpBzLAea6Wewzyko1Hefv5pdX+kO2qmB2MQJLdZZlpuP
        aIA+BSwTRzugwAAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E526313911;
        Tue,  5 Sep 2023 12:24:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 3Gq1Mhke92RZEwAAMHmgww
        (envelope-from <krisman@suse.de>); Tue, 05 Sep 2023 12:24:57 +0000
From:   Gabriel Krisman Bertazi <krisman@suse.de>
To:     Breno Leitao <leitao@debian.org>
Cc:     sdf@google.com, axboe@kernel.dk, asml.silence@gmail.com,
        willemdebruijn.kernel@gmail.com, martin.lau@linux.dev,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, io-uring@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com
Subject: Re: [PATCH v4 09/10] io_uring/cmd: Introduce
 SOCKET_URING_OP_SETSOCKOPT
In-Reply-To: <20230904162504.1356068-10-leitao@debian.org> (Breno Leitao's
        message of "Mon, 4 Sep 2023 09:25:02 -0700")
Organization: SUSE
References: <20230904162504.1356068-1-leitao@debian.org>
        <20230904162504.1356068-10-leitao@debian.org>
Date:   Tue, 05 Sep 2023 08:24:56 -0400
Message-ID: <875y4obyef.fsf@suse.de>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Breno Leitao <leitao@debian.org> writes:

> Add initial support for SOCKET_URING_OP_SETSOCKOPT. This new command is
> similar to setsockopt. This implementation leverages the function
> do_sock_setsockopt(), which is shared with the setsockopt() system call
> path.
>
> Important to say that userspace needs to keep the pointer's memory alive
> until the operation is completed. I.e, the memory could not be
> deallocated before the CQE is returned to userspace.
>
> Signed-off-by: Breno Leitao <leitao@debian.org>

Likewise, much cleaner!  Feel free to add:

Reviewed-by: Gabriel Krisman Bertazi <krisman@suse.de>

Thanks,

-- 
Gabriel Krisman Bertazi
