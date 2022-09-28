Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC7035EE096
	for <lists+io-uring@lfdr.de>; Wed, 28 Sep 2022 17:35:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234213AbiI1PfQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 28 Sep 2022 11:35:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234395AbiI1Pey (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 28 Sep 2022 11:34:54 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76CDD5D0EF
        for <io-uring@vger.kernel.org>; Wed, 28 Sep 2022 08:34:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=From:To:Date:Message-ID:CC;
        bh=u/5AbGEUsGFXD7xgD9DFhT62jyGZsFbUUS4KvUsFPJI=; b=ux8fgCZxceDGZLlvOQ20vTeu/F
        Vu8QOQhgX1UbTZKkiNMtIgFg0bJOaVJmkwrajEz8I0/ZgHSk0z4o9CcmRKEPHtxTJVOTOmIz8DNC5
        MTgK9VudHhTJVnXc2YQP9huLu40l2V/4TOE+jhcGQdweGhpAkuMmPqC0SfmAP3EztKDtv0n1hPGin
        ME7ULNFuz9ELvdWu3lqrY/uOgE18CDh6BcntaF30I/Qmg0op8o2ojc0+lX03sTfxjjvcNUUwMaGEx
        L4ADrHSL9siXa5M1xjWa4Ip0zVYcp6uAsUXDxPylax+a+7KbJdzTSBXeGqICKe7ne6U918TXGUBM9
        CLuLtadwmxlwB/12geHgYF+FC+Vt2sanT7HRrfI1oKvSsf269pYgM2jvP5xBLcVHhlJ/65wUencPp
        +S5ecRmdLNQ4tTTjaSt9NczbvVCot/EulSFvZWslF0+ih5n996dNHnam7uCFhk622zgGwE6myVvRr
        Ogoua0mplwW9goGNWs8U4Fkp;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1odZ59-002FAc-R6; Wed, 28 Sep 2022 15:34:43 +0000
Message-ID: <65aa69ee-777f-0069-03d5-d3b6cd2af609@samba.org>
Date:   Wed, 28 Sep 2022 17:34:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
From:   Stefan Metzmacher <metze@samba.org>
Subject: IORING_POLL_ADD_LEVEL doesn't provide level triggered poll...
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


Hi Jens,

I was testing IORING_POLL_ADD_LEVEL, but it doesn't have any test nor
does it provide level triggered poll.

Currently it provides a deferred edge triggered notifications.

As it's new for 6.0 and doesn't work as expected can we revert it
for 6.0?

I'll try to write up more details about problems I hit when I tried
to add a io_uring backend for Samba's tevent library in the next days.

Thanks!
metze
