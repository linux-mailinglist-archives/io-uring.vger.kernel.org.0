Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94CE77B5EE1
	for <lists+io-uring@lfdr.de>; Tue,  3 Oct 2023 04:02:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbjJCCDA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 2 Oct 2023 22:03:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229793AbjJCCC7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 2 Oct 2023 22:02:59 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26C86BD
        for <io-uring@vger.kernel.org>; Mon,  2 Oct 2023 19:02:56 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id 98e67ed59e1d1-273e3d8b57aso93259a91.0
        for <io-uring@vger.kernel.org>; Mon, 02 Oct 2023 19:02:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1696298575; x=1696903375; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BZrutkVbMBVvwGrOxYI2YPR8cwqjWmpv0Ny3maTyQSA=;
        b=qX0qGz9+zJA6vNyPx+JUGhBtIhf8i1pj6Ut3SHjMO3Ia4hVOnwkkLUWAe3mtSfhVNF
         TBL3SsNSiUbnyDji5RG9925xUtfrPy5atcEmK2YFbotcHAsk0nlGJDJxkgDq7liq9LxX
         FeycdGHh7uZp0Kv+nLXpSqmQhOcZ0n230hzDu/ffsiAiaFj881eTL2y6gajBx6sZbAP/
         dyuDI2/wRk+tlMtOCgCJxMUZ8OawBYloHkiGfHoYt6ZiynW68lCIcrDWrfCG6tcCIydL
         p5p/NKaFiTVHKlnW907IV7D4k2cIABUFYhhSdc46RUzuFsOp05vD9Iqw7VSUNvrqdmLC
         OtNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696298575; x=1696903375;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BZrutkVbMBVvwGrOxYI2YPR8cwqjWmpv0Ny3maTyQSA=;
        b=VXbvKLfQaXSRlMnG7oHxvgwHzSZI3w6XV5VWpTlYHGHwDKQRsPFWn9ZmkI9M2/fdfI
         a8CWVos2OVLXXoXRsX6T1i4gpa3xUND/n8WmLNTvJ8sCBAkxriNyFluMWp6e5LO65R9o
         c5mCUELvOdF6W0xgREg2CUBqkmgVuhhA+lxN4uhNK+6H9jbVtFOu6K7yBPAT4UhViYUE
         nbBrD1WpVNUxudRHQH4a8UDjgmW8JvjSZJqJrncC8lgzwsy/AeCvbt9tmGCsKUB/jqtD
         ZQjsrQqPmWWK6zUoRa4Opx6/cfxEDpRm9saEfKIBoTjXlKPdeQDPsn7ABrQ/EmKppY0Y
         XHWg==
X-Gm-Message-State: AOJu0Yy9H581Y2wYaDSRlSVOyySJEaJw78yH7hONdtLBOIhb+6npOx05
        8qhlF2wk9x6jTZApObgpj+GJKYQpygRi2ya46zQ=
X-Google-Smtp-Source: AGHT+IEuWEhHJST/y24EjhDuOhffSUWx6PWRgK+57cfZ06wCgMiDDVN2Q26yzEWLwc9BJwdzImg2wA==
X-Received: by 2002:a17:90a:4506:b0:268:ca63:e412 with SMTP id u6-20020a17090a450600b00268ca63e412mr11816933pjg.4.1696298575608;
        Mon, 02 Oct 2023 19:02:55 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id v14-20020a17090ad58e00b002777ba600fdsm6903982pju.25.2023.10.02.19.02.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Oct 2023 19:02:54 -0700 (PDT)
Message-ID: <04086fa2-8506-4f6f-8b31-3b539736adc6@kernel.dk>
Date:   Mon, 2 Oct 2023 20:02:54 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] BUG: unable to handle kernel NULL pointer
 dereference in __io_remove_buffers (2)
Content-Language: en-US
To:     syzbot <syzbot+2113e61b8848fa7951d8@syzkaller.appspotmail.com>,
        asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <000000000000af635c0606bcb889@google.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <000000000000af635c0606bcb889@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

#syz test: git://git.kernel.dk/linux.git io_uring-6.6

-- 
Jens Axboe

