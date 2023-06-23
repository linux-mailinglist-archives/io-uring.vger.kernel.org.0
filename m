Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E868173BC27
	for <lists+io-uring@lfdr.de>; Fri, 23 Jun 2023 17:55:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231463AbjFWPzz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 23 Jun 2023 11:55:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229673AbjFWPzy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 23 Jun 2023 11:55:54 -0400
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1572210F4;
        Fri, 23 Jun 2023 08:55:53 -0700 (PDT)
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-312863a983fso873188f8f.2;
        Fri, 23 Jun 2023 08:55:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687535751; x=1690127751;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uh2s7pfKdwDVYLhDB6xiD5fS/jgZntuMD4WczwZds+c=;
        b=W5cTMJDIB4AEdIXR8/zwjnYTvAutrUXDTc+YRmfzDuUBOeeEj2FaTjqhFRaWVypcQu
         BX7Nb7cQdM6oL1+5N6wKxUp14uAm1T/mWmcOzAPnDvfDjcXfE4AgSpsfHPliwEffVlyn
         kaHdAOSP5SdGjAH2ffpc5wN0yYBhph/KU7+4Ftk3ttCIm2hX7XI2LAGsQNP3P8/B/RDW
         UYZwde5psvEs00sMAB+sc5JxCgL56VSG8IjoX5xGmb4NEMgAPyl8h7XisjeZGWutvzgZ
         IEoTJmmbBni6BsumIS9MCa9/zfNlo0j373s0Q3QviwJ612p1LDs0Z7olR1ZhRiq0QGYD
         R2VA==
X-Gm-Message-State: AC+VfDxQLCzvXxlkBhZ/J+2F3fke5I8Y0T1xmmY/FObZgfS1GhbnJC06
        HVltNCx/Ebq2VU8WSRZrWPc=
X-Google-Smtp-Source: ACHHUZ6Zp6T87cPbwjyq2Omci50vJWOHyJKeJos303G8+PX7I3bWhWvhQBcgABRbjRIfjewho9XkFA==
X-Received: by 2002:adf:e982:0:b0:30a:f3ca:17bb with SMTP id h2-20020adfe982000000b0030af3ca17bbmr14850056wrm.35.1687535751248;
        Fri, 23 Jun 2023 08:55:51 -0700 (PDT)
Received: from gmail.com (fwdproxy-cln-117.fbsv.net. [2a03:2880:31ff:75::face:b00c])
        by smtp.gmail.com with ESMTPSA id r15-20020a5d52cf000000b0030af72bca98sm9849120wrv.103.2023.06.23.08.55.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jun 2023 08:55:50 -0700 (PDT)
Date:   Fri, 23 Jun 2023 08:55:48 -0700
From:   Breno Leitao <leitao@debian.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "open list:IO_URING" <io-uring@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Subject: Re: [PATCH v3] io_uring: Add io_uring command support for sockets
Message-ID: <ZJXAhINndD49qo5M@gmail.com>
References: <20230622215915.2565207-1-leitao@debian.org>
 <2023062351-tastiness-half-034f@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2023062351-tastiness-half-034f@gregkh>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Jun 23, 2023 at 08:39:02AM +0200, Greg KH wrote:
> On Thu, Jun 22, 2023 at 02:59:14PM -0700, Breno Leitao wrote:
> > --- a/io_uring/uring_cmd.c
> > +++ b/io_uring/uring_cmd.c
> > @@ -7,6 +7,7 @@
> >  #include <linux/nospec.h>
> >  
> >  #include <uapi/linux/io_uring.h>
> > +#include <uapi/asm-generic/ioctls.h>
> 
> Is this still needed?

Yes, this is what is providing the definitions for SIOCINQ and SIOCOUTQ.
If we don't include these headers, we get the following compilation
failure:

	In file included from ./include/linux/socket.h:7,
			 from ./include/net/af_unix.h:5,
			 from io_uring/rsrc.h:5,
			 from io_uring/uring_cmd.c:12:
	io_uring/uring_cmd.c: In function ‘io_uring_cmd_sock’:
	./include/uapi/linux/sockios.h:26:18: error: ‘FIONREAD’ undeclared (first use in this function); did you mean ‘READ’?
	 #define SIOCINQ  FIONREAD
			  ^~~~~~~~
	io_uring/uring_cmd.c:171:32: note: in expansion of macro ‘SIOCINQ’
	   ret = sk->sk_prot->ioctl(sk, SIOCINQ, &arg);
					^~~~~~~
	./include/uapi/linux/sockios.h:26:18: note: each undeclared identifier is reported only once for each function it appears in
	 #define SIOCINQ  FIONREAD
			  ^~~~~~~~
	io_uring/uring_cmd.c:171:32: note: in expansion of macro ‘SIOCINQ’
	   ret = sk->sk_prot->ioctl(sk, SIOCINQ, &arg);
					^~~~~~~
	./include/uapi/linux/sockios.h:27:18: error: ‘TIOCOUTQ’ undeclared (first use in this function); did you mean ‘SIOCOUTQ’?
	 #define SIOCOUTQ TIOCOUTQ        /* output queue size (not sent + not acked) */
			  ^~~~~~~~
	io_uring/uring_cmd.c:176:32: note: in expansion of macro ‘SIOCOUTQ’
	   ret = sk->sk_prot->ioctl(sk, SIOCOUTQ, &arg);
					^~~~~~~~
	make[2]: *** [scripts/Makefile.build:252: io_uring/uring_cmd.o] Error 1
