Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A1CA14FED2
	for <lists+io-uring@lfdr.de>; Sun,  2 Feb 2020 20:07:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726921AbgBBTHy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 2 Feb 2020 14:07:54 -0500
Received: from mail-pl1-f175.google.com ([209.85.214.175]:37516 "EHLO
        mail-pl1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726893AbgBBTHy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 2 Feb 2020 14:07:54 -0500
Received: by mail-pl1-f175.google.com with SMTP id c23so4945588plz.4
        for <io-uring@vger.kernel.org>; Sun, 02 Feb 2020 11:07:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=aGe2kixKl5Xf6QPQdGzL0aEJ6FUqIQ5dTaRmjNKCvj8=;
        b=fEqhPPX7PE1JNAMpjN5G9eaudSfsPJLnCBesP+u9xTxIt7C/VYVsBG7HDeSfFcxW8t
         +jB4vi75LfvpN+5qQhdZ30Lt0UkZFpLfoI1IOP+kFHBEOwM4GOowJBzNrgeyM8kVmx7C
         SfEWXppHEG8Gim1Fse9rfk3Lahud7iW+k2nV7Nkjwj7TG3nJrtIn5sfeChsQ2SuzJ+pA
         oA/6On4QrJ1HMPkkr0FYY/7aApZz8sM2ZZtrfm2Xu/HC6JYbNtHN/+pki5aQlCZRgO9i
         z6S0qlI10hWkEhrymOqswVrBsz9G2OZNihGKsKNvLsmP0QNXsh+NdUgUKlCcbZeMywOy
         W9VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aGe2kixKl5Xf6QPQdGzL0aEJ6FUqIQ5dTaRmjNKCvj8=;
        b=VEGMlTJmbEcOPeuHHFMok+NJrBYiraxmKby/Ok0JD28/FWlS5CFzzqViUZtmQwZ6ic
         OqXOo7xNdK8PL5pSa1i6nF3wzeDZiP7SLoDXMrlp+3RYPXtzHKw4eu3ZDRfAOywEQVpe
         sJYE2hVMlmDWsPzDGa+umej3uet6i8XyGAVqfEh2ZtC45Co0mwfg7OfPyF05Im36kr8U
         e58DL+ur/Dndigg2YhBlc1en+Tb+7Z2fj6pzyiJuGMEl6x+61Sw0tutGuvwPkAhs5AIG
         Uq4x79YRH8NVUAQ12ww4YkSe3PU8uw+xWlz44BCcv25hQPqINBa1uJhxuTYX0dEsHj7H
         1NAQ==
X-Gm-Message-State: APjAAAVFakzUHedR0u3c1iCPqzfkBBhh128cb7B0OkApSAPkw+nRLSn4
        heIMjxD7550rrUE43LVioS2bww==
X-Google-Smtp-Source: APXvYqyfJ4KZJqXQkiZ2cZR/Yjsa6Js3ZT0bv0ZplE5WsVUVrQoGU26cvJjR7bz6W95L2V/KkiY9lA==
X-Received: by 2002:a17:902:ac83:: with SMTP id h3mr20003793plr.86.1580670473820;
        Sun, 02 Feb 2020 11:07:53 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id r7sm17883087pfg.34.2020.02.02.11.07.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Feb 2020 11:07:53 -0800 (PST)
Subject: Re: liburing's eventfd test reliably oopses on 5.6-94f2630b1897
To:     Andres Freund <andres@anarazel.de>, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
References: <20200202165619.etu4s7lpfi24nwrw@alap3.anarazel.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <939d7b34-2cf2-1192-2056-a71018be6c3b@kernel.dk>
Date:   Sun, 2 Feb 2020 12:07:51 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200202165619.etu4s7lpfi24nwrw@alap3.anarazel.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/2/20 9:56 AM, Andres Freund wrote:
> Hi,
> 
> Updated to linus' current master (with just one perf build fix applied
> on top) for reasons unrelated to uring, got the oops below when running
> the uring tests. It's sufficient to just run the eventfd test.

This is known, I have a pending fix. I did gate the test on 5.6-rc, but
that'll only truly work once I ship those fixes out this week.

-- 
Jens Axboe

