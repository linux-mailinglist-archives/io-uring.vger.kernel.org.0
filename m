Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DBD325CEAA
	for <lists+io-uring@lfdr.de>; Fri,  4 Sep 2020 02:04:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729405AbgIDAEg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Sep 2020 20:04:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725782AbgIDAEe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Sep 2020 20:04:34 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8EF5C061244
        for <io-uring@vger.kernel.org>; Thu,  3 Sep 2020 17:04:34 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id k15so2333479pji.3
        for <io-uring@vger.kernel.org>; Thu, 03 Sep 2020 17:04:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version:git:git:git:git
         :content-transfer-encoding;
        bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
        b=uIcMNisRB6lDSxjWLEc9ap8cEnlxpp3N43ih+M26wC03TfmXl4vi8YpMiw574B+W2+
         IpNyP4qnbtUJWjTKf6MXXN3NF/77jkU8LF1V3edXoJ1af6iIz9MZyKVa49gLFsxK4hzU
         uvpizhMKVjgsBjUe3k5MNoCblADGIlJNwuj/5X8Ud9xEzrnSpOC9GW8IwUf0B6pP6lxI
         qTHxonWKI64qn11YGgrrplNVFlp4SheitC+SjXkBwcjwWwrZPJ0LeRu08jjzNNKlvVIF
         lBQsFaQ9JchL1ptaLxjvwak27fYbnKq3g1BSq67dKRsnOTUGfvlXu7NCg7NlqSkQvRYK
         M4lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :git:git:git:git:content-transfer-encoding;
        bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
        b=dbu3GLcG8veKFrvWVZBoht2CKos9knlbxqy4H0z0wgFsVnX7mJ+TnzwO742qEnvakT
         EvpgGfnLgImRJk7A1bks/BGWSwjvCQEYlW8aTWI+BP+4TMqBbdzPfqu3q8zX3h1GAJqs
         CDznx+M7IenWkBwKOx30t5sml2LGkI5FMnJaMOrihMsJoT38QcGQOgY7RhosrnoPAIXL
         zsNEaFyxIbi089HNXN6fJIo2xOlULAWyXYmxNrdnnyoPIhmuZCRcy5Q4JLzA7rANEhby
         B7FNkWT6te4EBBfwBaOXmKANV5rRVFRcqbZMk8TtR+7wter9++hODC+bfLD3/qdwqg/D
         yM3Q==
X-Gm-Message-State: AOAM531GY/YeQCumTPWqVMjvHtsr2GAXQkOnOqvFy1NS1kAKoK91uP7b
        d6lBBcFsI9OMptlbEyi644d8l+3pm+ol2o0r
X-Google-Smtp-Source: ABdhPJygvN7mwrBoecR6tWoyGzdCceXK9aFluS3hqtQSC5D7K+zQSDyju0v7TMeH5pe494+f6+zRAw==
X-Received: by 2002:a17:902:7404:: with SMTP id g4mr6475310pll.176.1599177873180;
        Thu, 03 Sep 2020 17:04:33 -0700 (PDT)
Received: from localhost.localdomain ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id v8sm18894482pju.1.2020.09.03.17.04.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2020 17:04:32 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: 
Date:   Thu,  3 Sep 2020 18:02:27 -0600
Message-Id: <20200904000229.90868-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
GIT:    Lines beginning in "GIT:" will be removed.
GIT:    Consider including an overall diffstat or table of contents
GIT:    for the patch you are writing.
GIT:    Clear the body content if you don't wish to send a summary.
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

