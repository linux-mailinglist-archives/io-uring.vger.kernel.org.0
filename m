Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B63D062C9BC
	for <lists+io-uring@lfdr.de>; Wed, 16 Nov 2022 21:12:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233591AbiKPUMR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Nov 2022 15:12:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233773AbiKPUMO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Nov 2022 15:12:14 -0500
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A628663EB
        for <io-uring@vger.kernel.org>; Wed, 16 Nov 2022 12:12:13 -0800 (PST)
Received: by mail-io1-xd33.google.com with SMTP id c7so11421827iof.13
        for <io-uring@vger.kernel.org>; Wed, 16 Nov 2022 12:12:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uAIRNQs5iDGpgvnmMqchV5FJF+Z7OrBknVTiJuEzL1w=;
        b=L3k78kfkktINV1pymAAim4PNRbpyaLqKDJgJACcsI6KNl+2exKlzVRGV28+g4ia8hV
         rhSn6gAguklHE4ui0lOABS1Y4uUQ7saXPXbqDB7Vw9+192NWWy1RBzeC0aFjivT5cj+6
         w136QZsGqaaIwg70NbON6VYU0fDqvqdhRDYbCcLNZVPHZrFB1iXioBTjRYa8Y/8Pbhva
         sFXVg2pmWkAuey0TU+t/NlC37/H7Tm/Usr1JlT6BAyrTkhuc26KywRvJMhw+TjjcAfMF
         yHdcZ7HOwdO9uOl3nevlcVSR9yk7tzrWVcVTR8m5eXw9YPUcXP3txRK44ge6e9JWDPCA
         YdYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uAIRNQs5iDGpgvnmMqchV5FJF+Z7OrBknVTiJuEzL1w=;
        b=uDGW4ML+Wi2BBwLr4QY7eXPVn5X9Lnpp0wbu8+k9NvH/UG5CX4fSswQy43q8p43Atz
         hbiA0P0fjFCAq4nKLITJ0m91Y7lZrqn+5EoWOnctneP/A12Iu9mwBx2BNkWq4ymTPvgh
         /7XpkHzY3RmGY9TtDrloTpJrRR7ydpl/Rhw1sdAO2SikbZfRDQNH39saQhZzK+lqFPPq
         RNzH84Ln9Z30nJXwvUCdI5zqQFv2JhAXm+1sB9U2Xz5/U8853VhcNIvXhNykzvQd9KOs
         inQ96Uw7MY+6S93K255vCJvpezvFNi09JO1mgJZIlvdUzNK6kxnKGWEIVYA+Wg58xLDt
         5r+w==
X-Gm-Message-State: ANoB5pnue7jjREulqxjKm4P0NBhpJkAx9u1LGURQsXgGd4q4ehp0JuLz
        x6AkEHRUkYV++N3lvw/iU8tbWw==
X-Google-Smtp-Source: AA0mqf6tsvdSZn9Txbg5IS41rZYBF124yYY+TUxcHbZoOfzcMcrLqPVeVf6or1CvrQMN4jNdKInY8g==
X-Received: by 2002:a02:a002:0:b0:376:e17:5eaf with SMTP id a2-20020a02a002000000b003760e175eafmr7801439jah.56.1668629532632;
        Wed, 16 Nov 2022 12:12:12 -0800 (PST)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id e19-20020a056602159300b006ccc36c963fsm7026418iow.43.2022.11.16.12.12.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Nov 2022 12:12:12 -0800 (PST)
Message-ID: <0dca5179-8ac1-326c-1a87-2c6f96bff7dc@kernel.dk>
Date:   Wed, 16 Nov 2022 13:12:11 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [RFC PATCH v3 0/3] io_uring: add napi busy polling support
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Stefan Roesch <shr@devkernel.io>, kernel-team@fb.com,
        olivier@trillion01.com, netdev@vger.kernel.org,
        io-uring@vger.kernel.org
References: <20221115070900.1788837-1-shr@devkernel.io>
 <20221116103117.6b82e982@kernel.org>
 <44c2f431-6fd0-13c7-7b53-59237e24380a@kernel.dk>
 <20221116120941.2d7cffcd@kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20221116120941.2d7cffcd@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/16/22 1:09 PM, Jakub Kicinski wrote:
> On Wed, 16 Nov 2022 11:44:38 -0700 Jens Axboe wrote:
>> Thanks Jakub! Question on the need for patch 3, which I think came about
>> because of comments from you. Can you expand on why we need both an
>> enable and timeout setting? Are there cases where timeout == 0 and
>> enabled == true make sense?
> 
> The enable is for the "prefer busy poll" mode, rather that just busy
> polling.
> 
> The prefer busy poll mode disables interrupts and arms a (hopefully
> long enough) fail safe timer, and expects user to come back and busy
> poll before the timer fires. The timer length is set thru sysfs params
> for NAPI/queue.
> 
> Because the Rx traffic is fully async and not in control of the local
> app, this gives the local app the ability to postpone the Rx IRQ.
> No interruptions means lower response latency. 
> With the expectation that the app will read/"busy poll" next batch of
> packets once its done servicing the previous batch.
> 
> We don't have to implement this bit from the start, "normal" busy poll
> is already functional with patches 1 and 2.

Gotcha, ok makes sense to me. I'm fine with the patchset, just want
a few adjustments on the API side as per previous email. I think
Stefan is respinning with that, then we can get it queued up.

-- 
Jens Axboe


