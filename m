Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 161F2539E21
	for <lists+io-uring@lfdr.de>; Wed,  1 Jun 2022 09:24:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235628AbiFAHYV convert rfc822-to-8bit (ORCPT
        <rfc822;lists+io-uring@lfdr.de>); Wed, 1 Jun 2022 03:24:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236045AbiFAHYT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 1 Jun 2022 03:24:19 -0400
Received: from cloud48395.mywhc.ca (cloud48395.mywhc.ca [173.209.37.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCC6A4EA3A
        for <io-uring@vger.kernel.org>; Wed,  1 Jun 2022 00:24:17 -0700 (PDT)
Received: from [45.44.224.220] (port=40496 helo=[192.168.1.179])
        by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <olivier@trillion01.com>)
        id 1nwIJF-0004GD-OE;
        Wed, 01 Jun 2022 02:58:25 -0400
Message-ID: <ddcb0deaa314e1541da86c8b2b297ae291a2b72e.camel@trillion01.com>
Subject: Re: [GIT PULL] io_uring updates for 5.18-rc1
From:   Olivier Langlois <olivier@trillion01.com>
To:     Jakub Kicinski <kuba@kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>
Date:   Wed, 01 Jun 2022 02:58:25 -0400
In-Reply-To: <20220326122838.19d7193f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <b7bbc124-8502-0ee9-d4c8-7c41b4487264@kernel.dk>
         <20220326122838.19d7193f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Organization: Trillion01 Inc
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.44.1 
MIME-Version: 1.0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cloud48395.mywhc.ca
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - trillion01.com
X-Get-Message-Sender-Via: cloud48395.mywhc.ca: authenticated_id: olivier@trillion01.com
X-Authenticated-Sender: cloud48395.mywhc.ca: olivier@trillion01.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, 2022-03-26 at 12:28 -0700, Jakub Kicinski wrote:
> On Fri, 18 Mar 2022 15:59:16 -0600 Jens Axboe wrote:
> > - Support for NAPI on sockets (Olivier)
> 
> Were we CCed on these patches? I don't remember seeing them, 
> and looks like looks like it's inventing it's own constants
> instead of using the config APIs we have.

Jakub,

No, you werent CCed on those patches. No one, including myself, did
think that you would want to review code not in your subsystem and
running scripts/get_maintainer.pl on the patch did not list your group.
If not receiving an invitation did upset you, I am sorry. This was not
intentional

Can you be more explicit about the constants and the config API you are
refering to?

