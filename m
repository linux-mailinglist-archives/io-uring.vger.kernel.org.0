Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B519275E413
	for <lists+io-uring@lfdr.de>; Sun, 23 Jul 2023 19:43:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229566AbjGWRny (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 23 Jul 2023 13:43:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjGWRnx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 23 Jul 2023 13:43:53 -0400
Received: from s1.sapience.com (s1.sapience.com [72.84.236.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5A11180;
        Sun, 23 Jul 2023 10:43:51 -0700 (PDT)
Authentication-Results: dkim-srvy7; dkim=pass (Good ed25519-sha256 
   signature) header.d=sapience.com header.i=@sapience.com 
   header.a=ed25519-sha256; dkim=pass (Good 2048 bit rsa-sha256 signature) 
   header.d=sapience.com header.i=@sapience.com header.a=rsa-sha256
Received: from srv8.prv.sapience.com (srv8.prv.sapience.com [x.x.x.x])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (secp384r1) server-digest SHA384)
        (No client certificate requested)
        by s1.sapience.com (Postfix) with ESMTPS id CC9B2480A2C;
        Sun, 23 Jul 2023 13:43:50 -0400 (EDT)
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=sapience.com;
 i=@sapience.com; q=dns/txt; s=dk-ed25519-220413; t=1690134230;
 h=message-id : date : mime-version : subject : to : cc : references :
 from : in-reply-to : content-type : content-transfer-encoding : from;
 bh=qvqDvJ6z1X9pX7Hz0D/dTmd7iKskTuw2eAbBlB2IUA8=;
 b=GGLUkJ31b4aqlIQt6HoDwqanAilkCW4FtvSMmEaSUEWT8roDn1k8IDTXeU9/j4cjtxi4r
 qPOq30SiHCc03OjAg==
ARC-Seal: i=1; a=rsa-sha256; d=sapience.com; s=arc6-rsa-220412; t=1690134230;
        cv=none; b=gFmye88JIl45MokehuUtQWprJPFmv7a9r6IGfDUrgigK3yUbjgfDDVr/MtDdxANlFUhzSGW0Lpuqs+zbA/ZmMT96X8y2BuUVbuBkkAaTXPPt7+PURlGtQSSw7zYyHf/lWuw1DNi8cEgKMCFUh4bCCsenwR0tZB+kWCh+qJ0lYB7tzeLrvBDItB8LgTMcG9VE2Bhl6VhIrQIo4cnt/6o1Prw04LXZ4bFEWeYYIhSbZF8BMV18lTHK7QX8K0mUnApjUhf+7XMpf4r4/O/hVZmglxiXtPj9HoYNy3MInkdw/U1I0k6BtgVBDSVQ3jGVEIW2dBENxp5YSxZMkkAz/dgqEA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=sapience.com; s=arc6-rsa-220412;
        t=1690134230; c=relaxed/simple;
        bh=kbvOZxDd3f2v9gt1kWG06Fh7pqlACOQ1tCnubhOp440=;
        h=DKIM-Signature:DKIM-Signature:Message-ID:Date:MIME-Version:
         User-Agent:Subject:Content-Language:To:Cc:References:From:
         In-Reply-To:Content-Type:Content-Transfer-Encoding; b=pEhJWsHNWS261GrUVRCnR0TcDCNy443AuPHsEGsKUDXhZLVoZXrn5z45HBlDz5Ukj6DV52+a2o0jKX35cOliJovQLfFvuLXAtMbw/RPpSNzJP9weWmlcjNoDY8CL4h/yZhr1hhM9Z/aR91CnCYdQw5dcp0cMF4h4cvGpt5uBu+IGdToW0tRrwm21nGgbNF6OszShZNBGDiwhCfgl5E2WebmUbJx/l3n1ZshcopPcydb8llK8temdPXeebJ79fPwNUhDP4R8HL1Ly64X542sYT8YyW+o93ta1CPUBmmGUzlnfy6d4ju9E9E0/JJEvue081JIhQoZaLo4fiOey1WjkpA==
ARC-Authentication-Results: i=1; arc-srv8.sapience.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sapience.com;
 i=@sapience.com; q=dns/txt; s=dk-rsa-220413; t=1690134230;
 h=message-id : date : mime-version : subject : to : cc : references :
 from : in-reply-to : content-type : content-transfer-encoding : from;
 bh=qvqDvJ6z1X9pX7Hz0D/dTmd7iKskTuw2eAbBlB2IUA8=;
 b=Rh9J5zY4+DAvkrIZm5dScnyFvaix14kjyjGMETV0BdlNQxJhVHoG1caSvcCsYEyBtS3XW
 4MvTZPFlixQGJXinr15KtsH+ALm7uyuSgTQwjxypmywiCVhGYbp36QsAUd4h16OUr4GjUtL
 w8VTlSw59g8eKtu6LPLD4UdA56reXpysz6aHsR2fCP6C4wso2G8JCpjvcPlX57cqbJ8yPMa
 sK23RKNraPim0NXEPAO8HhRIT9pqVG+b1IphPzKUeJ76kJjYoyp9XRGqFgX520Ke9FwMTKV
 vEECVchxult78U8gjgCxcY/JxvHVHq6Mr8LAEzBO2K1cCp5e64iISbZPS+5w==
Message-ID: <70e5349a-87af-a2ea-f871-95270f57c6e3@sapience.com>
Date:   Sun, 23 Jul 2023 13:43:50 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.4 800/800] io_uring: Use io_schedule* in cqring wait
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>,
        Oleksandr Natalenko <oleksandr@natalenko.name>,
        stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andres Freund <andres@anarazel.de>
References: <20230716194949.099592437@linuxfoundation.org>
 <20230716195007.731909670@linuxfoundation.org>
 <12251678.O9o76ZdvQC@natalenko.name>
 <538065ee-4130-6a00-dcc8-f69fbc7d7ba0@kernel.dk>
From:   Genes Lists <lists@sapience.com>
In-Reply-To: <538065ee-4130-6a00-dcc8-f69fbc7d7ba0@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/23/23 11:31, Jens Axboe wrote:
...
> Just read the first one, but this is very much expected. It's now just
> correctly reflecting that one thread is waiting on IO. IO wait being
> 100% doesn't mean that one core is running 100% of the time, it just
> means it's WAITING on IO 100% of the time.
> 

Seems reasonable thank you.

Question - do you expect the iowait to stay high for a freshly created 
mariadb doing nothing (as far as I can tell anyway) until process 
exited? Or Would you think it would drop in this case prior to the 
process exiting.

For example I tried the following - is the output what you expect?

Create a fresh mariab with no databases - monitor the core showing the 
iowaits with:

    mpstat -P ALL 2 100

# rm -f /var/lib/mysql/*
# mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql

# systemctl start mariadb      (iowaits -> 100%) 
 

# iotop -bo |grep maria        (shows no output, iowait stays 100%)

(this persists until mariadb process exits)
 

# systemctl stop mariadb       (iowait drops to 0%) 





