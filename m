Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 723EC667E44
	for <lists+io-uring@lfdr.de>; Thu, 12 Jan 2023 19:40:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240185AbjALSkS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 Jan 2023 13:40:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231814AbjALSjr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 Jan 2023 13:39:47 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE74B48CEA;
        Thu, 12 Jan 2023 10:13:51 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id e3so9706315wru.13;
        Thu, 12 Jan 2023 10:13:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pc/D2SDaMk1xth/YbuuniufVBsn6v0AG7i8rDiFenu0=;
        b=Q1+jM9KaS63fRLvFFOxaQ2gYcBDpc0cjCZUgAXRl5RocVwUrMRVfjYSyzxwiKmYcmT
         B/VI+f6fPyLlphLWb7sYsXJdOzlj9aDfUBmsBcdgMlaz0uDMZsAf4EhY0OO/LxMTucz0
         /3X4l8bSQzDSISXYbjLxHEmcKEyAjOPlJQb8bkCQfWU2IyD6cj2I1Z2DxJfAWorRTh4I
         63Ky3ctycPqjEmiqNAUep4BMSLv73cwSiNEmtbEhTquyfS6fg7mrWyH0jZp42evpcCMH
         nGA7NfjukMyuuhpNSNgljGB7TpaezKz4HOQFqSEZZfHExlnsII+bFaOwG4s7TVyS+5px
         bA+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pc/D2SDaMk1xth/YbuuniufVBsn6v0AG7i8rDiFenu0=;
        b=kdZdU71YJBbfWbopT0SPHmKhDq9itYudiSfdr0PKshZt0zgzqPUy4HJtNK57CjHhpQ
         CMsUvcMs5kdWyi+ZDjI4q9oWozcO6ul/oTTv0JTOEPbvcTyu+AfcYYYbMk72SCfYbWcy
         bTxp01iHGMp2p0k2DuuJjiYvGc7W6RgWqEaD+2Qlquxv3Y0VT8PST9+p38kJSPkQyxXO
         hLUIZu2tPd7q1cyGS71L4Rk1I8dFhvbDMJyfcyQ4kuQ59OfRQ1vT5vwcWyjCe2zc4ImO
         ZA87FjrYi62vJ9LfE0Y620fmGcWhmenqE1RNX/9aN5iFhWxmYcFOWdzZb+HgwsH1hK9O
         7ebw==
X-Gm-Message-State: AFqh2kpRjHsMDCu1PRiBpiJF/AhrMxGmX+MEY57kJyuyPhd3qxuJGaQd
        6xDXftc7QFTRtbZ9XHwt5EY=
X-Google-Smtp-Source: AMrXdXtA+Ut7IFqfWgetK5U0//ZESyjqP5JbrRTGijJXlk79/0qG8uLpYAjV+AN661+G8iaFPnNtlw==
X-Received: by 2002:a05:6000:1b05:b0:2b5:dc24:e08e with SMTP id f5-20020a0560001b0500b002b5dc24e08emr17701959wrz.69.1673547230305;
        Thu, 12 Jan 2023 10:13:50 -0800 (PST)
Received: from [192.168.8.100] (188.31.114.68.threembb.co.uk. [188.31.114.68])
        by smtp.gmail.com with ESMTPSA id l6-20020a5d4bc6000000b0027323b19ecesm16917901wrt.16.2023.01.12.10.13.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Jan 2023 10:13:49 -0800 (PST)
Message-ID: <746dc294-385c-3ebb-6b8e-7e01e9d54df5@gmail.com>
Date:   Thu, 12 Jan 2023 18:11:59 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [syzbot] WARNING in io_cqring_event_overflow
To:     syzbot <syzbot+6805087452d72929404e@syzkaller.appspotmail.com>,
        axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <000000000000694ccd05f20ef7be@google.com>
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <000000000000694ccd05f20ef7be@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/12/23 10:56, syzbot wrote:
> Hello,
> 
> syzbot has tested the proposed patch but the reproducer is still triggering an issue:
> WARNING in io_cqring_event_overflow

#syz test: https://github.com/isilence/linux.git overflow-lock

-- 
Pavel Begunkov
