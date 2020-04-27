Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DA631BA95A
	for <lists+io-uring@lfdr.de>; Mon, 27 Apr 2020 17:56:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727104AbgD0P4A (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Apr 2020 11:56:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726539AbgD0P4A (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Apr 2020 11:56:00 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00DEDC0610D5
        for <io-uring@vger.kernel.org>; Mon, 27 Apr 2020 08:55:59 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id i19so19367655ioh.12
        for <io-uring@vger.kernel.org>; Mon, 27 Apr 2020 08:55:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/yE9SwQfeIeHyVe4ISb3/2+ArE3gkGzZXnHf9N3n4X0=;
        b=Bn7LZ+aaBBQEdl+yaeJJ75RSt7gB9vlpAkf/XyQTxg9hYT3pjJG1bce1kakhTBKz+1
         izk9DtfKdfgNUlNqxN+VLcItwb5/ojDY2Wp/c/9gOYKu7NBHJoJEewRQcWlRpxvPwc+l
         hnwDyAcv5QLHuoWkexRMJV/uHXqwyeNDle4FCGQv+YuwnyjixxRYhRuTAjF8n+sEETNp
         FzKOFfLNh0OGOXnBKSY1I3hsK7jUSvt5IwZDHcnoN1vMRWauQj/IeYdhbCJ0SEiXCj92
         5aFJHujCafAISd4Wi72oYS9baXFBqm10Cp1VQfU/UqvdqnmVNk6hQ7MXq/IUNrvvtlrK
         NbjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/yE9SwQfeIeHyVe4ISb3/2+ArE3gkGzZXnHf9N3n4X0=;
        b=mhOQP+aj7/Ii+ijax515bjwskRRf4yPAhRSmIFD+Idy0+CrK4KBcTWIm6i55mXUFqh
         0czt3RcDMzPo1xa2XiN9BMFIxI0xBM7HgZtIRDmjjffQmERVeNPEUeTiGvZmhlJVdKwI
         lYOm+hsb/OQsLzLbxR/A6VT5lrbpHjFlslOjmmr2OEqqEL+PX1I5KTtOizm83/NEexWB
         k/BGAJ1hY2pOhUZdxW7OBXyqRFGsSsDkzghWKuNPQ7G1TxC8iEgi/jim5nHPg+gMO1Um
         uhrMzdSdPnBVU5MMF/RdeHWZ8/aoJogU5Sxnu0URowqXEJP7QjJpyV+d50t18lpmdtC7
         ylAg==
X-Gm-Message-State: AGi0PuZQSR9KudlWXMC9rupkPq2r80czufYreDlHj4WeD4mujGtgYyrK
        FiXLiHpyyw5lceILYnarG5Cocw==
X-Google-Smtp-Source: APiQypLf0YGyy+zqDW1IpWyWbeiGXgkX3q53fNTwb8xo93edN+GFPxMGEI+/8bebTNsce8tKEFfXuA==
X-Received: by 2002:a5e:a810:: with SMTP id c16mr5439278ioa.99.1588002958369;
        Mon, 27 Apr 2020 08:55:58 -0700 (PDT)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id j3sm5055265ioj.27.2020.04.27.08.55.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Apr 2020 08:55:57 -0700 (PDT)
Subject: Re: Feature request: Please implement IORING_OP_TEE
To:     Clay Harris <bugs@claycon.org>
References: <20200427154031.n354uscqosf76p5z@ps29521.dreamhostps.com>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <c76b09f0-3437-842e-7106-efb2cac38284@kernel.dk>
Date:   Mon, 27 Apr 2020 09:55:55 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200427154031.n354uscqosf76p5z@ps29521.dreamhostps.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/27/20 9:40 AM, Clay Harris wrote:
> I was excited to see IORING_OP_SPLICE go in, but disappointed that tee
> didn't go in at the same time.  It would be very useful to copy pipe
> buffers in an async program.

Pavel, care to wire up tee? From a quick look, looks like just exposing
do_tee() and calling that, so should be trivial.

-- 
Jens Axboe

