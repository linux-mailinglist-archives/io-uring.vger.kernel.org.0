Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 092D452AB2B
	for <lists+io-uring@lfdr.de>; Tue, 17 May 2022 20:46:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230506AbiEQSqp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 17 May 2022 14:46:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351014AbiEQSqo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 17 May 2022 14:46:44 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 174773983F
        for <io-uring@vger.kernel.org>; Tue, 17 May 2022 11:46:43 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id z18so20262599iob.5
        for <io-uring@vger.kernel.org>; Tue, 17 May 2022 11:46:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=YIMbxTsLbrtbEFkaDSucwQrnGbAU6ETE/HBk7HXw4BM=;
        b=ASYaeDqOr6ZY8Y43feyxwUMnrIDRCO57Y0tCwbWFl1fPRaCrgk/PQQRdq2efcvraln
         /X+FbfFi9Q7SGYrJGRc0XaOjGtseOysVsi+cTdhgdSw1qncp9S3OgZB5D6DbqMyiJ5hN
         86YVYr8OEX0vDEhnAx/TE5NQmgBAFAwiHUMFkJ37NIGbDJ70ANJQWV1RjiSHL8rUc81z
         x3WLf6UbNTuBElaOYFc4+qMVk9N8FDx13MuSQJ2yk4WG7UtrEW81OFX7nRoxlOooDEUk
         Q0b5EjP7m4bBifoBEtc0mcnsvU18uL2OjPW/kEmoXC36Mo2Clp5Bl/Gr/WczDz9LUWtq
         GmOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=YIMbxTsLbrtbEFkaDSucwQrnGbAU6ETE/HBk7HXw4BM=;
        b=CW3ZxCABaKQeRwE0IdCf2vlr4MCuhfeQiZ1kf3Ez4KUGxE4G26Bzvldi0Y6d8hPcOU
         Zf3pd3wBj8NfHAvGW59Yko1pWOyWy3Z1h9KDo7vE2eOES7aM5tS6q2vX+AJ8plRB9kdT
         AWPXp9LAvLewIsUC6VSUnJrD8SL98n51MgvFWSSjql57HmjSVl8UX30z0MMNHceb7ovB
         Mu5L+5NWhqtymQoqxOMM+l4A3R44HeFUB3KufEk0P0AS6Du+2pWZ48Mawgka2+2x0F+v
         H/ghF4bDNdzcqGRFfjdfNUKHUhUzTON7REjjjZNh6ASJDqI1xf77IDzSspCR7vj7ojh0
         MAzA==
X-Gm-Message-State: AOAM531JCh8Szaaq7H3T3BTINFOGH8hQyNZgCH+XWVOq7g2va4qf5Xil
        iCK9o0z4mclcI0geoQ5tvxAiTA==
X-Google-Smtp-Source: ABdhPJwhs6oUxOuuvG3hk5YOfiQ6EgXRITTlIrL7zUmPYKqYM4mtvC+cg2zwyv9nGK+ZbzyvqCoyFg==
X-Received: by 2002:a05:6602:1510:b0:65a:edd4:cdb4 with SMTP id g16-20020a056602151000b0065aedd4cdb4mr10853963iow.143.1652813202389;
        Tue, 17 May 2022 11:46:42 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id o13-20020a056638124d00b0032e30453802sm1804804jas.47.2022.05.17.11.46.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 May 2022 11:46:41 -0700 (PDT)
Message-ID: <b6f36795-97ac-fac0-ab07-98de8255e4f9@kernel.dk>
Date:   Tue, 17 May 2022 12:46:40 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [syzbot] BUG: unable to handle kernel NULL pointer dereference in
 io_do_iopoll
Content-Language: en-US
To:     syzbot <syzbot+1a0a53300ce782f8b3ad@syzkaller.appspotmail.com>,
        asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <000000000000c1bd6505df39865e@google.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <000000000000c1bd6505df39865e@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/17/22 12:44 PM, syzbot wrote:
> Hello,
> 
> syzbot has tested the proposed patch but the reproducer is still triggering an issue:
> BUG: unable to handle kernel NULL pointer dereference in io_do_iopoll

Gah, backport ended up putting the hunk in the wrong spot, not very useful.

#syz test git://git.kernel.dk/linux-block io_uring-5.18

-- 
Jens Axboe

