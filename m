Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D963588EE0
	for <lists+io-uring@lfdr.de>; Wed,  3 Aug 2022 16:45:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235852AbiHCOpz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 Aug 2022 10:45:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233008AbiHCOpy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 3 Aug 2022 10:45:54 -0400
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBD861145
        for <io-uring@vger.kernel.org>; Wed,  3 Aug 2022 07:45:52 -0700 (PDT)
Received: by mail-il1-x131.google.com with SMTP id g18so8581241ilk.4
        for <io-uring@vger.kernel.org>; Wed, 03 Aug 2022 07:45:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=KzbghDfdSYbbVIq8MCKfPQWqzLrz5hlmmphUKV17nu8=;
        b=VrwGdFtM972u2SZsV7dU/qli9q7dFaGblVnEZMi6+38WG0yo1xdG8g5NAgavvCs4LD
         IkuN7GavdiKiA450FdZ7eZQJHpUoueUxUkAsmf2y/IpMY8awhUo4GECa93l3pELF5h9z
         3Mh2RaTmbtGro7XLzkJX+eNA6oz1t99R9JdJk2ur5LyHsPWc7na/tJHQZ3x/yVdXj2Yk
         9KX7/xaCAJK3QjsiUXDL/pqeS7GV3iupQFu0wyWsdEpqdq0/0B6pSa3h8Rm3DoDj5Cyl
         AdB7z3B4QbkyDMZpSeBWoXYGhMKsn7uPjsaBP+/sBdnJZXiHyXRaoDDAc/IHYZyiP1CY
         kDUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=KzbghDfdSYbbVIq8MCKfPQWqzLrz5hlmmphUKV17nu8=;
        b=6h2RRHsuBZFlSLMHXKyRSs1ErHjdtOMUVWgZQzMlOLlXQW+1kUXgySKiOoGwrVbsa3
         FjJjiDJsQ+zDqh0mk7Mr6eaV+vq+mvv5zyWtACSccDdGHJ+VUOC8vSmX7YsZNFD40Wv9
         lHEd5VViHQhTQ5R3DeOX3TwZIgTw5hztsOsZwTP/cZ6nL7fvFbUdfuIulVuHmJHPIYJ+
         E5WsKx7wnSojr3ei3vgg/wc82duJ+D8OfchDBk4KA7Dx4aK/M3r1KMPkvPr9XB1CDEnR
         GbEbhFhxk06SVmw9asUxHEhPOu65PWBHPS2Vjh1WVfd8OAaRlWqky+somBLW/pBQxmke
         lU1w==
X-Gm-Message-State: AJIora/lzCOGZpd8ft1GSE7kkii33vFvt5CLzPjKicx5V8sBRJQI4/Fh
        ctgEHLtfIpGUITxr46Ds8e4w75OHfDmMBw==
X-Google-Smtp-Source: AGRyM1tkketHemFk7SuVg3qzLSj7VBsV7HEflsWZCEr3PO+G0V0uwZeHv6JX82/riGKA3yYsmbXgFw==
X-Received: by 2002:a92:dc88:0:b0:2dc:8c98:e3f8 with SMTP id c8-20020a92dc88000000b002dc8c98e3f8mr10334700iln.247.1659537951887;
        Wed, 03 Aug 2022 07:45:51 -0700 (PDT)
Received: from [127.0.1.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id x19-20020a056602161300b0067beb49f801sm8124751iow.2.2022.08.03.07.45.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Aug 2022 07:45:51 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     ming.lei@redhat.com, io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
In-Reply-To: <20220803120757.1668278-1-ming.lei@redhat.com>
References: <20220803120757.1668278-1-ming.lei@redhat.com>
Subject: Re: [PATCH V2 1/1] io_uring: pass correct parameters to io_req_set_res
Message-Id: <165953795125.476320.17259060949585037104.b4-ty@kernel.dk>
Date:   Wed, 03 Aug 2022 08:45:51 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, 3 Aug 2022 20:07:57 +0800, Ming Lei wrote:
> The two parameters of 'res' and 'cflags' are swapped, so fix it.
> Without this fix, 'ublk del' hangs forever.
> 
> 

Applied, thanks!

[1/1] io_uring: pass correct parameters to io_req_set_res
      commit: ff2557b7224ea9a19fb79eb4bd16d4deef57816a

Best regards,
-- 
Jens Axboe


